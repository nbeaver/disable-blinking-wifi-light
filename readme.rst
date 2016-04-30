=========================
Disable blinking WiFi LED
=========================

This is a script to make the wifi LED on Intel cards stay lit when enabled
instead of the default behavior of blinking.

It checks that the enabled wifi driver suppports the ``led_mode`` parameter,
then copies the `<iwled.conf>`_ file to ``/etc/modprobe.d/``.
(This requires ``sudo`` permissions.)

Often the wifi module cannot be reloaded on the fly `due to module dependencies`_,
and will result in an error such as::

    modprobe: FATAL: Module iwlwifi is in use.

In such cases, it is usually easier to reboot
rather than try to determine which order to remove and re-add modules.

.. _due to module dependencies: https://unix.stackexchange.com/questions/106299/cannot-remove-iwlwifi-module-even-though-interface-is-down

----------
Motivation
----------

    This is really annoying because it keeps drawing my attention away from the
    screen. Is there any way to turn this functionality off and just let the
    wifi light stay on all the time as long as it has a wifi connection?

https://askubuntu.com/questions/12069/how-to-stop-constantly-blinking-wifi-led

    I still don’t understand how Intel can consider blinking the wifi LED
    during data transfer to be a sensible default. For most people it blinks
    non-stop which is both uninformative and irritating.

https://blog.al4.co.nz/2011/06/stopping-the-intel-wifi-led-from-blinking-in-ubuntu/

    At first this feature is nice, but after few hours it annoyed me a lot, so
    I found a trick to stop this annoying blinking.

http://www.xappsoftware.com/wordpress/2010/10/30/ubuntu-10-10-how-to-stop-the-blinking-of-the-wifi-led/

    The LED that indicates that my WiFi is enabled or not, was blinking every
    time the WiFi card transmitted or received data. This seems like some
    special feature Intel introduced but it is really very annoying!

http://www.tomdesair.com/blog/2012/04/stop-the-blinking-wireless-led-in-linux/

    Ubuntu in HP laptops has this very annoying habit of blinking the wifi LED
    constantly when traffic is transferred. This is very distracting, and I
    wanted it to go back to normal (that is, not blinking at all).

https://sumanta679.wordpress.com/2012/06/24/hp-elitebook-wifi-led-blinking-in-ubuntu/

    Personally I find the constantly blinking lights pretty annoying.

https://alexcabal.com/stop-blinking-intel-wifi-led-on-ubuntu-karmic/

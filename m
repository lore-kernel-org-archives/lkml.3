Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3J1VUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:20:13 -0400
Received: from scrye.com ([75.148.32.185]:53985 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3J1VUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:20:10 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2013 17:20:10 EDT
Date: Mon, 28 Oct 2013 15:02:50 -0600
From: Kevin Fenzi <kevin@scrye.com>
To: linux-kernel@vger.kernel.org
Subject: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
Message-ID: <20131028150250.755b4cc8@voldemort.scrye.com>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512;
 boundary="Sig_/28v8_FZxTWhswcEU1m4zUh6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/28v8_FZxTWhswcEU1m4zUh6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Greetings.=20

I have a lenovo yoga 2 pro.. it has a ELAN Touchscreen.=20

In 3.12rc5 it was detected and works.=20
in 3.12rc6 it was detected and works.=20

Sometime after the rc6 timeframe it stopped working. It doesn't work with
rc7.=20

In dmesg I get:=20

[  159.519663] usb 2-7: New USB device found, idVendor=3D04f3, idProduct=3D=
016f
[  159.519681] usb 2-7: New USB device strings: Mfr=3D4, Product=3D14, Seri=
alNumber=3D0
[  159.519683] usb 2-7: Product: Touchscreen
[  159.519685] usb 2-7: Manufacturer: ELAN
[  159.519901] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep de=
sc says 80 microframes
[  159.528027] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/=
usb2/2-7/2-7:1.0/input/input20
[  159.528544] hid-multitouch 0003:04F3:016F.000A: input,hiddev0,hidraw1: U=
SB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-7/input0
[  161.601423] usb 2-7: USB disconnect, device number 71
[  161.896828] usb 2-7: new full-speed USB device number 72 using xhci_hcd
[  163.991296] usb 2-7: unable to read config index 0 descriptor/start: -71
[  163.991301] usb 2-7: can't read configurations, error -71
[  164.143686] usb 2-7: new full-speed USB device number 73 using xhci_hcd
[  166.239273] usb 2-7: unable to read config index 0 descriptor/start: -71
[  166.239278] usb 2-7: can't read configurations, error -71
[  166.392576] usb 2-7: new full-speed USB device number 74 using xhci_hcd
[  168.487051] usb 2-7: unable to read config index 0 descriptor/start: -71
[  168.487058] usb 2-7: can't read configurations, error -71
[  168.640308] usb 2-7: new full-speed USB device number 75 using xhci_hcd
[  170.734850] usb 2-7: unable to read config index 0 descriptor/start: -71
[  170.734856] usb 2-7: can't read configurations, error -71
[  170.734927] hub 2-0:1.0: unable to enumerate USB device on port 7
[  171.022134] usb 2-7: new full-speed USB device number 76 using xhci_hcd
[  173.116744] usb 2-7: unable to read config index 0 descriptor/start: -71
[  173.116750] usb 2-7: can't read configurations, error -71
[  173.269840] usb 2-7: new full-speed USB device number 77 using xhci_hcd
[  173.282520] usb 2-7: New USB device found, idVendor=3D04f3, idProduct=3D=
016f
[  173.282526] usb 2-7: New USB device strings: Mfr=3D4, Product=3D14, Seri=
alNumber=3D0
[  173.282528] usb 2-7: Product: Touchscreen
[  173.282530] usb 2-7: Manufacturer: ELAN
[  173.282782] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep de=
sc says 80 microframes
[  173.290920] input: ELAN Touchscreen
as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input21

So it seems to be bouncing in and out (but never long enough to actually wo=
rk).=20

Could be a regression in xhci_hcd?=20

Happy to provide more info/details/etc=20

kevin

--Sig_/28v8_FZxTWhswcEU1m4zUh6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJSbtD8AAoJEEs3sNgP+7tebSgQAJnbciJMs9KuXD7OGgViztkb
6WAnxR6CT/23CpZsRZ7ira5EZRjk1TiDgn6dFK2dqNmbiW+ITzqRIMajTje/E6QA
u0Qwc6MHImMYBMkCfS1d0mzPSt+m+Yr6FJ3BG3lVyaBZCd4J227nYTikBLaDu2ab
hEQ8szfrLd7LvvbUtCBp1xgRF1Ycw1C70m1uiE49AW4Y3M/L+l5xY+lWG7mXUnuD
4nlg7tYJRIXcbldyTvFUHdDvZEhy0b8I4NKa/jU3kkqXgZWexfMo3pOMntSCxiTW
uZCkxTkgHq1uYiJY1geIJLCzQ+IMH7r5+IJChj1NKQLwtsstZDvArBjzDAIr4jpU
564471e3vUodYFNjcEQoj7MqRTFVuL3f6JYyqADt/w0wjaWCDvQ9JpkFwM5RLQ3o
vdjozCzt1hMOBjUIAbiHzxK+GsJkcYVSBZaWeO2gwxCTPH8KAg8ghcOj29ldI8od
wUoUW1PwCtGa2p3tpduKhozSeWy1RhqBGIGavIMIPG1UokLhG2OJe3C0GwWoIVzX
75+vmsbBVto7nFZce9ODGgZAqErp0lwINJPmdR27hM9qHZxEPZAMBQEEzwSnDLAc
gj0OZ6rC8SyzMMLM8GTA4iWz0S4eosWmaTwBkS2HpxWUYFUqbDC/xwOSE0v+dbOA
p8JiDevxn3aNz8yDKGnY
=UKYr
-----END PGP SIGNATURE-----

--Sig_/28v8_FZxTWhswcEU1m4zUh6--

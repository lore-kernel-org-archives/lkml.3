Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaJDSmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 14:42:55 -0400
Received: from mout.web.de ([212.227.17.11]:54550 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaJDSmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 14:42:54 -0400
Message-ID: <54303FA4.3080106@web.de>
Date: Sat, 04 Oct 2014 20:42:44 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: xhci_hcd: WARN Event TRB for slot 6 ep 4 with no TDs queued?
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5J1TnRtptdOsrHOlgb5KKwQhdlwQJR6FD"
X-Provags-ID: V03:K0:Tsx2bfleA9b0rdVzo6MbeFR1gbjiBXqXoBkzG5Pv4bgVXvnHp3e
 /BwM7UVJPPu5wjBy8OuuB2AocgytpOIcPGPWCzdm1Fh1650Xowqr2Oz4YKwMHW6dlm4SxOj
 uJEYesRi0uX81AJb6dhB57BcFbTEdMFKUY2rRamwF3AugZHJwdzzUBWrq1fjAsb1OjuvNdH
 p4DVdF6+BeiOrtSYto3dw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5J1TnRtptdOsrHOlgb5KKwQhdlwQJR6FD
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm getting

xhci_hcd 0000:00:14.0: WARN Event TRB for slot 6 ep 4 with no TDs queued?=


on each interaction with my built-in CCID smartcard reader (Celsius
H730). The device is working fine otherwise, just the log fills up.
What's the reason? What can be done about it?

Find lsusb -v of the reader below.

Jan

---

Bus 001 Device 006: ID 0b97:7772 O2 Micro, Inc. OZ776 CCID Smartcard Read=
er
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0b97 O2 Micro, Inc.
  idProduct          0x7772 OZ776 CCID Smartcard Reader
  bcdDevice            1.10
  iManufacturer           1 O2
  iProduct                2 O2Micro CCID SC Reader
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           93
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass        11 Chip/SmartCard
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0003  1x 3 bytes
        bInterval             255
      ChipCard Interface Descriptor:
        bLength                54
        bDescriptorType        33
        bcdCCID              1.00
        nMaxSlotIndex           0
        bVoltageSupport         7  5.0V 3.0V 1.8V
        dwProtocols             3  T=3D0 T=3D1
        dwDefaultClock       4000
        dwMaxiumumClock      4000
        bNumClockSupported      0
        dwDataRate           9600 bps
        dwMaxDataRate      307200 bps
        bNumDataRatesSupp.      0
        dwMaxIFSD             254
        dwSyncProtocols  00000000
        dwMechanical     00000000
        dwFeatures       00000030
          Auto clock change
          Auto baud rate change
        dwMaxCCIDMsgLen       271
        bClassGetResponse      00
        bClassEnvelope         00
        wlcdLayout           none
        bPINSupport             0
        bMaxCCIDBusySlots       1
Device Status:     0x0001
  Self Powered


--5J1TnRtptdOsrHOlgb5KKwQhdlwQJR6FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQwP6sACgkQitSsb3rl5xTJRwCcDSpVWZ1v8qUv0QFUHOiWkVSr
1v8AoL1xzZ6Q4+8fULmyMyWMZd6fTeth
=b4fd
-----END PGP SIGNATURE-----

--5J1TnRtptdOsrHOlgb5KKwQhdlwQJR6FD--

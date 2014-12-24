Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaLXRPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:15:19 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34071 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaLXRPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:15:17 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.19-rc1 refuse connection from bluetooth headset
Date: Wed, 24 Dec 2014 18:15:12 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2208885.mAYkt4clhk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412241815.12922@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2208885.mAYkt4clhk
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

now I installed 3.19-rc1 kernel and my bluetooth headset was refused to con=
nect automatically. I need to start=20
connection manually from laptop (and then it working). Before when I starte=
d bluetooth headset it automatically=20
connected and I did not have to do anything. Now with 3.19-rc1 kernel I nee=
d to do connection manually and I see=20
error messages in hcidump:

 $ sudo hcidump=20
 HCI sniffer - Bluetooth packet analyzer ver 2.2
 device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
 > HCI Event: Connect Request (0x04) plen 10
     bdaddr <HEADSET_ADDRESS> class 0x240404 type ACL
 < HCI Command: Reject Connection Request (0x01|0x000a) plen 7
     bdaddr <HEADSET_ADDRESS> reason 0x0f
     Reason: Connection Rejected due to Unacceptable BD_ADDR
 > HCI Event: Command Status (0x0f) plen 4
     Reject Connection Request (0x01|0x000a) status 0x00 ncmd 1
 > HCI Event: Connect Complete (0x03) plen 11
     status 0x0f handle 34 bdaddr <HEADSET_ADDRESS> type ACL encrypt 0x00
     Error: Connection Rejected due to Unacceptable BD_ADDR
 > HCI Event: Connect Request (0x04) plen 10
     bdaddr <HEADSET_ADDRESS> class 0x240404 type ACL
 < HCI Command: Reject Connection Request (0x01|0x000a) plen 7
     bdaddr <HEADSET_ADDRESS> reason 0x0f
     Reason: Connection Rejected due to Unacceptable BD_ADDR
 > HCI Event: Command Status (0x0f) plen 4
     Reject Connection Request (0x01|0x000a) status 0x00 ncmd 1
 > HCI Event: Connect Complete (0x03) plen 11
    status 0x0f handle 35 bdaddr <HEADSET_ADDRESS> type ACL encrypt 0x00
    Error: Connection Rejected due to Unacceptable BD_ADDR

(real address of my bluetooth headset was replaced by <HEADSET_ADDRESS>)

Can you inspect why new kernel refuse connection from my bluetooth headset?

I'm still using bluez 4.98 (which is in Ubuntu 12.04), I did not do any upd=
ate.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2208885.mAYkt4clhk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSa9KAACgkQi/DJPQPkQ1J5eQCfRwRIieQReU8tMzqwBtMzCCSl
WCEAoKCy/wdc/dsO+bsRvAbXCQmEl5+2
=BqDw
-----END PGP SIGNATURE-----

--nextPart2208885.mAYkt4clhk--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3DRGFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 02:05:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51723 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3DRGFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 02:05:53 -0400
Date: Thu, 18 Apr 2013 16:05:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20130418160541.57123749577f29665fba7839@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Apr_2013_16_05_41_+1000_I8KQ.6MuGAUGgazv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Apr_2013_16_05_41_+1000_I8KQ.6MuGAUGgazv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-usbat.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-sddr55.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-sddr09.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-realtek.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-karma.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-jumpshot.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-isd200.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-freecom.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-eneub6250.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-datafab.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-cypress.ko] undefined!
ERROR: "usb_stor_dbg" [drivers/usb/storage/ums-alauda.ko] undefined!

Caused by commit 75b9130e8af6 ("usb: storage: Add usb_stor_dbg, reduce
object size").  Please build test such infrastructure patches with and
without MODULES ...

I have used the usb tree from next-20130417 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Apr_2013_16_05_41_+1000_I8KQ.6MuGAUGgazv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRb401AAoJEECxmPOUX5FEH3MQAJ1P0f0tapn6B8uojqw7jMal
ytl1iJZCXCC5pKkRn7n2KuyUZIJPF+nbAEYgLUD3NyE2erwDXMOFk9nCU2ZY6zIu
rbZb1QVsLKp2TpuLljE2IeuPYcHD7BoVU1vCDg58DmhefuBVFR32AeFN0YiBQRDB
G8F4rmLGFjBc/zTzham1jw5Yw1HkGQOSVmZXd+ATuSjIt1bXqE2LAxafUcX5TaOY
5vLkA2LjCQvdzHNHYd2kK4UzGtdinz6tQIyL1l63MQu3cJ9fpKxNc+6F4G1D2jre
mlANgOL39h5jKyT5IaAq4wfwJW93jKqnnF0eH2AIyRNA8s0ofVJPTBz+iD0TUU7o
OrLD3V9x8t5xBrfw2JM9ylKLiDdNAhVmVmpuboWZQkhcqSBBu6aoOP4pQXc53O5z
DleobQZy4HbRTCFPY+hpHL+JOZGcDvVgD1IliSWpPoANKSJEBiaBVQ5s3PPl0+vR
+PCtbeLNbFYvLGT/NnF8vlzp0bov4zhwRKz98Yn0woZgQo9U0mgdwCWqkNxc88g7
r1ITELbqNh7uNzdqBqJaSSHiEnfFJSO2l48Q6RcbGBNP5Dpctuj2XPklEx1yqpUL
VLnHOftR9bLNfXGOdK7Wjdujv5iforaT5LeBsS7xstL8DfWCa95XEAOiiNRB6T9W
5bgdcB8BjBGWg1EhN6iE
=mMm6
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Apr_2013_16_05_41_+1000_I8KQ.6MuGAUGgazv--

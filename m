Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3FFHct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:32:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55585 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3FFHcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:32:47 -0400
Date: Thu, 6 Jun 2013 17:32:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: linux-next: build warning after merge of the final tree
 (driver-core tree related)
Message-Id: <20130606173243.ba35169ddc8bcc32a81a9669@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_17_32_43_+1000_nfEbYV0M=It.ofOd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jun_2013_17_32_43_+1000_nfEbYV0M=It.ofOd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
produced this warning:

drivers/base/firmware_class.c:921:13: warning: 'kill_requests_without_ueven=
t' defined but not used [-Wunused-function]

Introduced by commit ddf1f0648e8c ("firmware loader: fix build failure
with !CONFIG_FW_LOADER_USER_HELPER").  This build does no have
CONFIG_PM_SLEEP defined.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Jun_2013_17_32_43_+1000_nfEbYV0M=It.ofOd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsDsbAAoJEECxmPOUX5FEykoP/jdERTKT9ZFbhq0IAk9DSsQ9
w9F4MQrHdXZ1tlw/MySs3di18iOSPur88FUNxbaK+hYWi5kzdI1zONfO2Wm1Qwpy
/pz6Su7+aZGFJ/ZqlARwv/AO6eM1kjcc6KxMJMyj7vMuNOPtbcqeCY8FraoldO/O
+S6kThj5Tho/HbrBsVFm1ROmoiMETuD6VlLQzPg39rRbHT2nbbo1WDptAbLE5DzE
qqVrAYEgLIlGUJgy0RMcTojIUd4W6xCntLQOByUxTXkMbSEkCBu8vV2jlIF9B/dw
qVBxF4TB0uo4dk3vVLBTMOclNRGJtJDBarc8E8y5gWSwZdfhnlqajtSoS3L57X8a
D1UUFg1Ftgk/KVNT4tEPbmkG+4uEoYrDE1MA4JDyjtLW1vNWpV4rt/CR05n8gO+K
DdDmZcHJZKGVjjU37vx1ziZcDKYLH1RhIM9r5pfOHl0COZ8kpzg085+ITYRCfo0d
il7XvZsYspfHDXCOtUCRer+XZvEmv+aiDndYop68Fyxvg85y3znhNsNSgHzBlbHK
XNw//MXZObrlk3e2ayqZ8CR1jZM5oH6WwunrPkntjKg4cjNNxD1lyXkL4ydO/CDb
fC2yfnSCTfghY03wBDk3+4pMqWKbqwifZDMdLryGVdsm6pim57NkM1DdyDe7ZtlI
7uH23zj2lmeCAiMGBgQG
=kwil
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_17_32_43_+1000_nfEbYV0M=It.ofOd--

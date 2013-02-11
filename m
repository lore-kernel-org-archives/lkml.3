Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3BKB7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 20:59:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45753 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3BKB7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 20:59:07 -0500
Date: Mon, 11 Feb 2013 12:58:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: linux-next: manual merge of the acpi tree with the pm tree
Message-Id: <20130211125856.64b216a03dd18218c4627635@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_12_58_56_+1100_CUvPppz+P.Y8_fcr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_12_58_56_+1100_CUvPppz+P.Y8_fcr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
drivers/acpi/processor_idle.c between commit 4f8429166818 ("ACPICA:
Cleanup PM_TIMER_FREQUENCY definition") from the pm tree and commit
41cdb0efc42e ("ACPI / idle: remove unused definition") from the acpi tree.

I fixed it up (The latter removed the lines modified by the former, so I
did that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Feb_2013_12_58_56_+1100_CUvPppz+P.Y8_fcr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGFBgAAoJEECxmPOUX5FEkasP/1s8Mcu9q5Gsrfvi1O04dxRf
Snqa9gGvo0WgIZWzAvCDLggsX62uZbXy2DiahFMxyFWwIFDzWFXNf8RHAZx9J05V
HS09NsMPgZiks6RpGXCdZGIpNyqMLYv4Bth+jvL5T/HKAXqEER4AfZT/RceIADP2
1VB4zV4magX2hpQkCYvXwz3B18vYro2Js7CJWFmb6If95Aev2NyxSDbZ4gdhbVlO
UWH5b53GW1PO08RbVj9cSyjy9ZwjggqVZhowme2wbvIEN6gVRog5XVDqi6SV2wya
pai8G+L/kK0vad5Qz6enk92DO6yBprzyOhXfRXdvS1N35M0bGJ2Uz8rDggFBLup5
CRCpJF+08chgWSzej0SJ/dOKGx8fLc6fFtAqsTVzXBXQshLecUnLbEoGFzwzUZJK
/5CtxxCBWXkDTAb4gwq4h54J+CedcqFWZwuCbg73FWuHHbi3YrTYnHqJRHykhDM2
GlyE8s9wgl+peRbZhO2O2Cqa0g32wCdFLy7N0B5MwlQuu7//sv7KCY+IXbREOF1e
MBOjFA23JEtzNRFlwi7ttdrRwaP4XEQPaXxStoqnbyFUhkCidlliBBpr9MNApH0C
TsrNeocR0rNjR47IjHjDUJvhkp0dK5DuQAeKj9IDkOB3XYCGUcj6yMcEMjzXLlC/
33bk9HGOLHrAIv94uu0Z
=FTKh
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_12_58_56_+1100_CUvPppz+P.Y8_fcr--

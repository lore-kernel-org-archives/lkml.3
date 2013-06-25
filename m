Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3FYIeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:34:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56332 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3FYIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:34:04 -0400
Date: Tue, 25 Jun 2013 18:33:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: linux-next: build warning after merge of the driver-core tree
Message-Id: <20130625183355.464b44df82ffc033aab31a4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_18_33_55_+1000_SKPzg8R=TZwYm.0p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Jun_2013_18_33_55_+1000_SKPzg8R=TZwYm.0p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
allnoconfig) produced this warning:

drivers/base/firmware_class.c:221:29: warning: 'fw_lookup_buf' defined but =
not used [-Wunused-function]

Introduced by commit 90f8908127b5 ("firmware loader: fix compile warning
with PM_SLEEP set").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Jun_2013_18_33_55_+1000_SKPzg8R=TZwYm.0p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyVX3AAoJEECxmPOUX5FERPQP/3So5kuFDiK4fFMwcPst4R5E
N9QtezTD2xqPQsGjCSQGQhskxfkCS5xRyzA6k8pfnRyclp+tYe1SIHyEc5XdIRkg
jl2Nn0zeoJ5eq5HnmG1aokgpW0aTG+2IH8V1CdjztGRSkdVYP1yAWK/STdpK8r1X
+fZhGrsMTmYBy29d2Alu3rlPCXclYwwHH7/5jHXjEKTwbuKt3Gk7ZW3WGSFWIAgG
Zm9DjIYiod4N7cssdzqUJbO1Wj4tWK7GKe2uaDNGrCY34c6JefM7FZklJB3aVzo8
IZQUPncbOYQxtNzmkQVPET8a2nQ0ZNh102aeOglCAhgp5LjtN8jTklnMHZiAImpi
+xfEnh6R3Lr3U49gbeYfpcJ27hSg4r6unk1A5A52dIl0t+BucbLYopvOrsXBdpDK
QahV8XCMfZYjBP2COB2KH3mtxL3rASk0fuJZxa94i8ZSt/Dw6lrgA14zpDB6/Hhz
kJ4HaOYRCqlWn/ghC6LBF+N6b4cs78gFyC6zp6EcSDIC+pgl7EgmW4lzLU5hqflh
wLQr+4H/spdysKx8UsrSTyDznImvnM9iVnGHg+924vh+812ZBRkz+JKIMhc2uOtc
Y/URM3w+qatBEW9F9PSvmBPn8j0PuhKCv+oD4bOMNDwwVu7j1VbpDPczR+FCsxwz
5yPytpYFlevaiTGGSpvi
=49mw
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_18_33_55_+1000_SKPzg8R=TZwYm.0p--

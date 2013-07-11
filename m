Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3GKAbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:31:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56503 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3GKAbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:31:18 -0400
Date: Thu, 11 Jul 2013 10:31:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rebase of the device-mapper quilt series
Message-Id: <20130711103116.72f41606b87698b476c4d371@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_10_31_16_+1000_MASO/j1d+9a7kKO."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_10_31_16_+1000_MASO/j1d+9a7kKO.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Why have you just rebased the device-mapper series
(http://people.redhat.com/agk/patches/linux/editing/)?  You have
just invalidated your testing and made it likely that Linus will blast
you if you ask him to pull your patches.  Your whole series was already
based after v3.10 (i.e. released or rebased after the merge window
opened), so why move it again?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_10_31_16_+1000_MASO/j1d+9a7kKO.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3fzUAAoJEECxmPOUX5FEbNoP/3Ns76k+ryn9rAq1XvBtH+5h
z6uAMDVRH3LeVVjWqjOMn+zdtu+zvcHDjly4Bf1JOYTdBet6a5461MUemJNk0Pf8
Ok0jBaGBjzKXhQL8wW9vpvW4BMCtvWErIINeAAS2gZbKwRdfqec8A4mQY4yOZ/2e
TW9EAAux70lWV8KsZgUhs7+qpDuaBNQsuN+JBA8Exok6vw4GZyEB3/E7VxOp9uW/
cV9dUE5Yd260TizZajKkH7Yhos/jyDWv4xcSfzvkxeC7vXiTbKIqQldHVAuFx/KF
BPVrTmACxyC7y02wWcrya+/vqtZ7+EleibDGlMQrUhbeQY465qivyGaiovDY4y7f
+cC0ZM1g00xUiJDllicatX6L2hpM/0XUm7E8fAuiV6hiSZW5f4LnepMB1BoDdL5Q
xz2f8dF2S4YB3iwB9I7KddP97l1jOoJz1AdKNosTDzrt0eFom4F1hne8iPbB5zpv
aKDbYIvtDps+yG7ITseWk/YEakoNwARHw+fKVqhdwmfFbuoiEfcHw+tst+hOTO4/
/VxPKc65+P+vFuAa95xpatNaCD3f7JCQ9aiiHdx7gZ1eVUIhqcMV41yzMwa55FT2
W75ZXcQ4fhV0SNge52Hbj5ZrLf+iM2sdFvFL/4Kjq9djA+mqbbozg5fIZ3HbRcxD
x3ImZR8owTI097ZpPr7N
=6rxs
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_10_31_16_+1000_MASO/j1d+9a7kKO.--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3GKAIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:08:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46707 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3GKAIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:08:52 -0400
Date: Thu, 11 Jul 2013 10:08:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rebase/rewrite of the renesas tree
Message-Id: <20130711100851.14dc2f2c5c268a23486c89c1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_10_08_51_+1000_ssKIRMv6wFEHV/HQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_10_08_51_+1000_ssKIRMv6wFEHV/HQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Why have you just rebased the renesas tree
(git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git#next)?
You have just invalidated your testing and made it likely that your
upstream maintainers will blast you if you ask them to pull your tree
(though it is probably too late for v3.11 now anyway).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_10_08_51_+1000_ssKIRMv6wFEHV/HQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3feTAAoJEECxmPOUX5FE4K4P/33W7EY/3hVxjiX72Vfyh7Ic
IPlwE5dixRgyEgPN62VdlvQR0EECGtadVT7rOqe0kTyjHREX2wpYpOWY5BQ1ObbV
SFzVHUktsBOkIqQmUaflKzi5WTY7hGWDI1XFUE7Tu0k0UmjoB5tl74Z6v3hJQhNo
hDDstyVMpvZaNRF1GKx8YNsBFm/B4j8nx42NHzqmhtV8By/on8ScodL4LTj7niGn
+2P/rBuH86yIMlj61LPGUAwyxgK/mMSngGW8N5X3ywbYXVM1p2eOdX/ioHR8uLiE
KlRWVHrKIeccPCkGEPyGXXbB76fFBAzrDyg0JoFrv96Aci7yAyNCjusTFeh/3/GA
xO+5FjyxyEEqV7yhvxwla67Yjp7ohQfzGOSefrhvosv0OA+0raI0WRwpY0uQrDyg
A1JTLMpum94Yox9hKH9gN4AdmOmARePKkCMTOb84bCuuCOQqKOdzFRaoqZjBNOLS
LQgoPw3/uyD1+8m/DaqvVLeo6r2PS56Uv9Da4dtDVqncmjpmMiNLpM45X/rronvt
DkeZqK2WH1dbijltsbljDwummqCksDzatL6Tz8ZkStu+dZiX/qcHybFeaJQb8r9w
r1zO14yjOut/f4QOWGRWIpQeQgPxU6Mv2AjbbzaYfEltXIEMp+NuCfpCFywcqMeG
6wNnZ5Nifk1GdwfdhAbK
=6Pso
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_10_08_51_+1000_ssKIRMv6wFEHV/HQ--

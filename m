Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaGQBkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:40:11 -0400
Received: from ozlabs.org ([103.22.144.67]:45516 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaGQBkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:40:05 -0400
Date: Thu, 17 Jul 2014 11:39:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: manual merge of the mvebu tree with the arm tree
Message-ID: <20140717113957.199f8e94@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8hK/grGIJAM3QWGPbAtScax"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8hK/grGIJAM3QWGPbAtScax
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/mach-mvebu/headsmp-a9.S between commit e77a0969a99e ("ARM:
convert all "mov.* pc, reg" to "bx reg" for ARMv6+") from the arm tree
and commit 435b4642e49f ("ARM: mvebu: use the common function for
Armada 375 SMP workaround") from the mvebu tree.

I fixed it up (the latter removed the code modified by the former) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/8hK/grGIJAM3QWGPbAtScax
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxylzAAoJEMDTa8Ir7ZwVvkoP/AliaaLAgMAhj5jFKUj/Q0+/
v2seEEOFElo2WvqUs3Daiw+XSPIcZczxp+s9YZfzEdCOzIoiHQPSeDCW2PYS5mu0
QqwYqUGdfTHt/iIHpo9CvlIylyg23ASBFobzJUo3anCUs0LiLXB3yyR/vo2Is8YV
g8jVOiH6YjgstwVnjP4pVlDySPENvamfxFBSDPnrTLK/gnL6NB7weZQwaZykAH1S
AfoyNBAKcO9sMjU/4MTvmF4dToJeXGJckNcLlj555Px0VlhcxnGLKnRlgXeTevRk
++QKOzIESNul4sK720WrndZiyAWB2bgCklLrsjMpkuxqJ9Lw5uGa03CempKgeLWq
iT8ruuh6jTqF1hQ2Gb8Zv9cfvPtimcfhm/GLNuSrWMzVNsoMxEwEws+1sruYHEqD
I3qYUnUz36iSbuMa5ds7d69C5AIp9YTwW7wp5kZQTCAboeyFCtejt9l9ej/EnIjj
Fs8QBsPIB8811KUiXLUAX0lLAVXfmGB9gZZUI6s42JOvbHHKVMJtPdF5zGQjC82K
1tANKiXE1Sw7a+uUtKpdZZrfXBNaGyAI4LRZzmelIZeJICDwW9UsifyfPDy8BX2p
KOW+alsOtFOWvaUuLueniN6L4USxCOuP+1fin9kAo2m48rPc0dw4dW9j7n6cKVV9
9mIuvY0tIDAGil/3JFwG
=+4zU
-----END PGP SIGNATURE-----

--Sig_/8hK/grGIJAM3QWGPbAtScax--

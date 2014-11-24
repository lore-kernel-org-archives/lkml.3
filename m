Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaKXGTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:19:18 -0500
Received: from ozlabs.org ([103.22.144.67]:48465 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbaKXGTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:19:16 -0500
Date: Mon, 24 Nov 2014 17:19:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20141124171908.034b2fa1@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p+yLM8q3xdlWZ19mojmqv4S"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p+yLM8q3xdlWZ19mojmqv4S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "get_xsave_addr" [arch/x86/kvm/kvm.ko] undefined!

Caused by commit 1d7fe1d1fb18 ("KVM: x86: support XSAVES usage in the
host").

I have used the kvm tree from next-20141121 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/p+yLM8q3xdlWZ19mojmqv4S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcs3hAAoJEMDTa8Ir7ZwV8HMP/34Rbbe2XRrqWyF6q17BDWUy
JUPsVAjfpl8mc6x8awehOD6sF4E9n9sw2r63kCF47C4c6zw+mdF7jePuXciUX5Qe
IRGxK7xV7+ZJ9YsWwMNt7rzlrBQvoAiTJqjax2tpXeAGunEtZ4f6/NEP2TX72wcH
ae12tovDZtAbLyXiMR4LNjgkIvCUZ0ZRH06aLlPlb2tTqxb7d0fpUv2xAYed+m5l
TrPD9VtRv18o/nnnmYHjNVXUcTHrSETGTroVwReT04CysVf3IE9AXsuIyc/F3Utp
JRgkkoKqsp4xcyVtAqZ4CfwF/p10+AjzWRCGpRfsu6iE5DeMBQrEEVBby5rxuoMO
AlvMW9kfzXlLQCou5DBr+rTKhruhS+JHesibjvJjIusSAtJHzaYiE/ukfhSz+grj
z4bHLm8j4b+MWhDz/urVglVhI8gxZjxZKO9IiLjJtpCvLh/UVPBAKYxTmKtR+tN6
6A3COSB3EuKiI3eRMhHO6qYvWZcMGGcMjL1CEp714AJ1Osdiy34EpJa21xVP6w6p
SNL9+yItjmeI9IRuph1M+wDatcfnCTQZMnprVpDoF7wZidYSdqOPTjhwEWXnlkfX
tXdX2PUSXm16pcYqb4AfFAVjuLByNl0pt1G8BoRh2H/0PAOMx90zzAauis4O6OMr
noFzdR3zpAIK8/u9bXpZ
=jDIh
-----END PGP SIGNATURE-----

--Sig_/p+yLM8q3xdlWZ19mojmqv4S--

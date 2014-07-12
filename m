Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaGLBUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:20:23 -0400
Received: from ozlabs.org ([103.22.144.67]:40165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbaGLBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:20:22 -0400
Date: Sat, 12 Jul 2014 11:20:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty.current tree
Message-ID: <20140712112012.69befaf0@canb.auug.org.au>
In-Reply-To: <53BFFD90.5010405@hurleysoftware.com>
References: <20140711112108.7631911b@canb.auug.org.au>
	<53BFFD90.5010405@hurleysoftware.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hoqn81_sTW5PymSGc6OSp4G"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hoqn81_sTW5PymSGc6OSp4G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Fri, 11 Jul 2014 11:06:56 -0400 Peter Hurley <peter@hurleysoftware.com> =
wrote:
>
> Sorry about that. I don't have a full cross-compiler setup for
> build testing. Looks like that's something I'm going to have to add.

see https://www.kernel.org/pub/tools/crosstool/

These are only good for building the kernel (no libc).

You don't necessarily need to build the whole kernel but often just
building the particular drivers is enough.  Especially if they are
directly modified ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/hoqn81_sTW5PymSGc6OSp4G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTwI1SAAoJEMDTa8Ir7ZwVP+cP/iSoJPo2DkkOEWRRuJjcKcMd
8kDjK6bbxHlr061TuXI7MdQFbtSPdRTZcsrWakf15+RwjyOQL5obQe6QlQIfoYjK
nOTDr4kZNNs0t9WfRMzf787zy8ruxY4W8tZO0ymb0hCL0oE4JSkuknw8ElXIYkz0
LR4ZXmKKPb8ZS3WELYsFhOTvCa5GhmbsAjR5rpNmsyffo7MEluNOJxgtWP8V4UC7
P+la295S0qb30KH7G72ZXnt7rWSSGHgwK8w2ZWyMy97Np+FSDcPWRtfnuHU0HPgP
Pd6/hR7kulNzrg/MqHpF6v8HAtZMoX0vpwMpTRB1fknHAo1Nfhs8Z0se6op3CGWH
sqmMxwFBC6f/A98oW0KaNCtauDP3b1De08d4mgDUYKTOCCInicU3VnUx5aH8gFlu
oQCB7AfoVRGzzFq0QHpP6aU5s3ApIXK3AWs+kC3dgZ1NRxzR9yLLDER8SoD8g/mP
vSJdq+lJt8Gc7J7WMLdyLdLiQizhnde/NMVhhVOF3AE+bcc+3aOklfFTissyhCh8
swChVTr/Spe/xegXRjaJhPuTF03ZT0N6TiqJXxht+DNU8xx+5/rb09rXQI6c/FLZ
YjVA2fPKk/CwnOaZwbAiwkARmT7yVqBX+lzSWlR25PD+ADoSBoBtILVE6uALSsSo
Ectqq2IqFtQDmyIL9B+h
=78fX
-----END PGP SIGNATURE-----

--Sig_/hoqn81_sTW5PymSGc6OSp4G--

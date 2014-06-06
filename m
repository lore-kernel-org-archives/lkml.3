Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaFFIWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:22:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaFFIWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:22:41 -0400
Date: Fri, 6 Jun 2014 10:22:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/locking/lockdep_proc.c: replace seq_printf
 and seq_puts
Message-ID: <20140606082237.GU6758@twins.programming.kicks-ass.net>
References: <1401993408-12126-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZsW/usBbx2ObC9TW"
Content-Disposition: inline
In-Reply-To: <1401993408-12126-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZsW/usBbx2ObC9TW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 08:36:48PM +0200, Fabian Frederick wrote:
> replace seq_printf by seq_puts and seq_puts by seq_putc where possible

Why?

--ZsW/usBbx2ObC9TW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkXpNAAoJEHZH4aRLwOS6BIoP/1OSmujIv3hphX5E+pNm3/7O
0gEOUqDZdHpkrRgIEPbXDV1WxnaIBZMN4tNBXDGtdHgYPf+gBErd/taEV7jZ/ZJS
pJU/rNuNuHa/c94oaUnCJDeMmELtIRmT+zYbD4nXSSz/MVYdwJjXEmzjN4Rh/lVl
8r7rLcgjMDtAoN44sTdiRniMhyjc1eV72XDyRg4Y4JKeIBCwo2ZU/m8+54q5GqGc
GS/XKl+foEbNvbFf8PUeircP7+zMCc5My6Jue5r+0+pykkvwXGVyzzFQ1hOQfkGB
SQYxCgW101Xyo1sy9c9SjdKTRggug265kdln5acBCDVWTtPwnjogLlWUdCopcVk4
MF147j3tDprRmRN/XSsaD+nq+/LJGas+8yrC9idrCt186AosODOmrxyYBJKM99Xj
UUEGIt8ZehznBMMkcVa1bXnV/PB2H1edxNaLvssdhNHdFPuPEodK89hI7e3lN0aL
eHGyVE5u/De2nmzXF+2K9qTP5MCoiY7iB0oiOMz8a6NyQsATSzWnt6c6QX1JkGni
P47OtxHoW8z+ggRaXnCN6Gx1kDFbVMZbuAO6o5XLrLLH5H+AJl/2d7xG2zlhGvOJ
63iGo7rAdijSoWdrWobTNFEkg0D/0vc9SbI35DFobuR+5+0aVKuucW4HWMl54bxG
NRIGY/H6/3J98Nfzp/zO
=obvJ
-----END PGP SIGNATURE-----

--ZsW/usBbx2ObC9TW--

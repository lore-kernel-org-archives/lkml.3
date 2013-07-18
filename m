Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab3GRJdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:33:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52187 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3GRJdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:33:45 -0400
Date: Thu, 18 Jul 2013 10:33:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130718093322.GC22506@sirena.org.uk>
References: <20130717141335.02a3ad620bdb473935d05aa3@canb.auug.org.au>
 <20130717083134.GB22506@sirena.org.uk>
 <20130718093824.d449a17a810f8898f815c199@canb.auug.org.au>
 <20130718120916.3bfd1ccdefdbc9e4fe907927@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tkgHWL40pCDFFyey"
Content-Disposition: inline
In-Reply-To: <20130718120916.3bfd1ccdefdbc9e4fe907927@canb.auug.org.au>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Jul 17
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tkgHWL40pCDFFyey
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 12:09:16PM +1000, Stephen Rothwell wrote:
> On Thu, 18 Jul 2013 09:38:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > So these are the errors I got yesterday:

> > sound/soc/fsl/imx-mc13783.c:23:28: fatal error: asm/mach-types.h: No such file or directory
> >  #include <asm/mach-types.h>

> > I didn't look closely enough, because this is the same error that I got
> > the previous day, but in a different file.

> I got this again today.

OK, thanks - this is the first report I've seen of this, I'm really
surprised the zero day tester hasn't been spottinng any of this stuff as
it's definitely running on the tree and sending me other things (mostly
warnings).

--tkgHWL40pCDFFyey
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR57ZeAAoJELSic+t+oim9YIkP/3mSzMjINyOgG867fwysBHPC
rkgYwdj+cdVx2GCqMM95wkS2qshJPb20M16z86MsF34M5N9KD4Tm3sE0BXUzlG3l
9ETSlyOZyt/fHCsnNXP2hfi/i04A+zGQAcKqdVWMK63ixs7ZoigwztecGvxGhYfS
oDnjZ1F6/Ilc0YH8oUXPP1E6h0bYPaT0bpEhdMlXrj2V3iHuT3uRi0iB0eZ9SKlH
9d17fiM9MXqF8KzvNa4hdyKUusUam6JPXHxktuP9HEpmbVJxBBARCFmeaYvxx2l6
XM5/F0NJoIwBepwiQy/Ah44HXN1pybHvTiPwZKIpCRypQdGZBrNRCt8c1Ms6aKDI
giMNvrro+ru0RYa22T3+CznizlNWgGs7FmoOAT+HRuQBkNFavdjPGbCSqp1b2YHQ
JhpUIybA92vrexhyCRLzgbsd1LIKb/ISu4+OTsctecQYgj/0sgF1l81RqP8b8oxj
ZWWJ0H6lAjptFXNRhHifWNKptx+5UApEzTBazjll0ZaJZrCJh5eKjcpS7vRNG0Zy
RKHTodjeBKXuW02xa9sesuFxg+eh1By3yBsj0aug2yhyxGhJ6chDwtTczUleopLM
n62blag+34SliF7OYE2Wv56hPa9idsr1gjbAl4YTbZxb3JHie3K/Gv2tYFbBGg3r
pDPn4F/L65Xqp1Pw9/8p
=HjPd
-----END PGP SIGNATURE-----

--tkgHWL40pCDFFyey--

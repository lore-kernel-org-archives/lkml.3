Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbaDPVcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:32:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35437 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaDPVcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:32:02 -0400
Date: Wed, 16 Apr 2014 22:31:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Matt Porter <mporter@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Message-ID: <20140416213141.GD12304@sirena.org.uk>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
 <1397501428-8857-3-git-send-email-mporter@linaro.org>
 <20140416110603.GA19671@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LAK3FBfgZ514qYSN"
Content-Disposition: inline
In-Reply-To: <20140416110603.GA19671@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] mfd: bcm590xx: add support for second i2c slave
 address space
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LAK3FBfgZ514qYSN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 12:06:03PM +0100, Lee Jones wrote:

> s/regmap/Regmap

It's consistently written regmap in all the documentation and so on :)

> addmap{0,1} doesn't quite sit right with me.

> REVISIT: Ah, it's address-map, rather than add map. Okay, not as bad
> as I first thought, but still, is there a better naming convention you
> could use?

addrmap or something?

--LAK3FBfgZ514qYSN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTva6AAoJELSic+t+oim9LLsP/1UtaZD4+crkbY14/E9wjarT
UnLzJHw+wH6iq6KagICOVoi2XkrpRDq14iYWdkZrct7Z7tlUaehHzrpEMwOZndfo
kKVIMwVvdhxtto2yAp0MnmlKloyo7vTj0WzF2VnliAnnbT/db+xXOpEF88X88wtd
6D3OrRRbx2YnRNI+A/whZrcYCBNCWQpPzJxv1VUpEUo3seaDHbAfnzj5+07KhpFM
hFeSPW92R2gOocEpNfKEVJoQJgArmM70nlldD67UaxgNcp33khTNfYdKhhScJp+9
i0pWQwl/IzUlhjKEX7IlQ+99yv+d6p8aJSc6dO8zgcKQwquBvEbdbN5KtlCuTfi+
EnNug7SSTB9BFzuSARqftr9y05cg95h+raIePVt3IiGiEKkzHG5dhZTEDCfDGglm
Yk/5WVgUDin5OIO6/QSTwMhT1pWck7oFbHzdHZhWMDE/VwhBCgnzGJXDShUCHhY0
eLEdxGkW2C5rUKp6dAocHp7w6NxAxJEqNs3yNT4OuIud4+mCy7TYWch+Xdtl0eRD
fYyOL0x93JDyyAgnN+D1VNps95pYrqio8JYQzz3667UYGrAM9HXLZYEd8jAV2si7
j1bdPlGOUybjBk2eGQ+vSFaINcXWW0AOaOXmwjVdSp8cTSKouXtijz6EUlX13/JU
uBa+VOgoolz3VZrRvuqo
=20+M
-----END PGP SIGNATURE-----

--LAK3FBfgZ514qYSN--

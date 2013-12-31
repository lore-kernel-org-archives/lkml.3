Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3LaQJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:09:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49211 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3LaQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:09:39 -0500
Date: Tue, 31 Dec 2013 16:09:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Kgene Kim <kgene.kim@samsung.com>,
        Patch Tracking <patches@linaro.org>
Message-ID: <20131231160916.GG31886@sirena.org.uk>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
 <1388053141-30085-1-git-send-email-tushar.behera@linaro.org>
 <1388053141-30085-2-git-send-email-tushar.behera@linaro.org>
 <20131229221723.12054.40917@quantum>
 <CAHbNUh0tJHXv52bA9hBDZMH0Pi+x9uC=LojcvgS=ONnCgEmVTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nkinyqrdwMuqz198"
Content-Disposition: inline
In-Reply-To: <CAHbNUh0tJHXv52bA9hBDZMH0Pi+x9uC=LojcvgS=ONnCgEmVTA@mail.gmail.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/4] clk: clk-s2mps11: Refactor for including
 support for other MFD clocks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nkinyqrdwMuqz198
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 30, 2013 at 09:33:50AM +0530, Tushar Behera wrote:

> Commit 1b1ccee1e821 "mfd: s2mps11: Fix build after regmap field rename
> in sec-core.c" is also touching this file, which is in Mark's tree
> right now. If I rebase

It's been in Linus' tree for a while now.

--nkinyqrdwMuqz198
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwuwpAAoJELSic+t+oim9XuQQAInHRRJf0L8pTVXq5Oy8bIAt
/ErX7ZJdqEH4pQASFZjYFg4RYR1zncbdzOLbto0f3OseBflj85R53EUWv/G0ERjD
o6cAj+CdisQC4G6FxfczXE5rDznOxPXPl8VJkfmZfjNKFi29TVItLzS27LR7+h4S
/lJ0+ZtR0Dzi8lx1hmnoY5DToUB/pC27OR8qXnsOc489fKG2V35TaK5slN6oSDd/
7ZiFKDO5FlbYVcOxREIPuILpIu16sN9HJOpKlW6YdJhbR0SFbc4EAn2HIX0C4AzG
vIVPDer9+vYUkj70tyM5lMEcC/T8WlgaIgJUYwjs1y1oRVHzT6PBIc5PIr3w3RZt
MutN8BfxN21QORvL9VIMrBBdVEXjMobPnFwlvb/2sEDwa7kpbCbQXQiGN+NCb4yC
WOE8sRY8HDDn2/gV32hIDqNJ+InZapFPu+bgc/lYIEZemjtkTmck6cpDJ52orrQQ
CY2Qmk+AsYG6egyOA82Wd3pCRBkzZPGGIxGZT6Hvdh7VLh1YNgvAU4siTj+NsXgF
1SQChOP551+FKEnloU+w6og1iiDrmqvhxaVfVs7XKVv286FpsWiXXu4Qk7dNvXQm
ILTAiWp8PNK2K3muC+/k/6+/OcGx0UGysKdaFFt36D1MTyX+BnzN2TPpl2aTvNGZ
xmXCnf6s3JdrFRZrNzWU
=6ur0
-----END PGP SIGNATURE-----

--nkinyqrdwMuqz198--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3ISLPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:15:21 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:37469 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3ISLPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:15:19 -0400
Date: Thu, 19 Sep 2013 13:14:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tsi108: Prevent compiler warning
Message-ID: <20130919111405.GA10852@ulmo>
References: <1379508595-30252-1-git-send-email-treding@nvidia.com>
 <20130918.123853.1464055976885078627.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20130918.123853.1464055976885078627.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 12:38:53PM -0400, David Miller wrote:
> From: Thierry Reding <thierry.reding@gmail.com>
> Date: Wed, 18 Sep 2013 14:49:55 +0200
>=20
> > The dump_eth_one() function is only used if DEBUG is enabled, so protect
> > it by a corresponding #ifdef DEBUG block.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> I would prefer that this function and the one call site is simply
> removed instead.
>=20
> This kind of thing can be provided via ethtool register dumps
> and therefore without all of the ugliness this ad-hoc stuff
> presents.

I just noticed the warning during some test builds I was doing due to
some unrelated patches and thought I'd clean it up along the way.

I'll send a patch to remove the functionality completely if that's what
you prefer, but I won't be able to reimplement it using ethtool. Perhaps
someone with actual hardware can do that.

Thierry

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOtx9AAoJEN0jrNd/PrOhnT4QAIelrNP+MLJmxaxZq7wfGqcZ
FViGIYuYfKPUjCYJ+jsihfyYJaLrpFsiYensrivPqEpdwRqOfYVY2jEw1AVRfwa8
x9oVRbnylRJlxY8ztBpY2vm1TEpBQn8aXa1YReELWtEe2f4yEmYWBIm6NpjoHlnn
Sc9UCtU0LMSaAY3/NRCutCEeEWYGF1I7b9ML4fPVYV61d+3hNAy+3vbZCugGUpM/
WtaXrFn0XRGsa5yS5uDCwUQEscTOFfqtvj9mxkxNrLy2BJyhUPMgvQzUqfFsAnAk
i1q1k++E9f4M4BDCfCQWB26oy92FC9K/hXQVtimQmIPM0vdLtq/cPm/67HY3+A84
avzN+XKPNHtMpQcxSrIUQnh0juLIoOlGBJD9tRGUbqOQS52pE10/AKlcjYWChNAb
3zZng+lkW2ug06nCpkPf8wlpO3KQz1Hw9LhCnAa6Vy6YYpPkLY76r32yEawHcs0z
Oc28mEqaFVCw7sUoCECnuV+0ZYSYO4SDGynEeouD+c/3yo3U3WcgQsh1L2gAtq2n
nN4HO7d7cJmC5u0DHkNff96IoRjcIT2XLdij2NbLYMzqV5N43BfyS0OQhuz9T6OM
xzLPsCqoNPBPJmZm/ljNrxNuOR0vlzJ9YJWfgxCq2lnc2KYtoeS2LSLCIIQd8I67
4U/jajMZbg9Pgi+r1Wcf
=SUIx
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--

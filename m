Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaJGMwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:52:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38598 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJGMwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:52:46 -0400
Date: Tue, 7 Oct 2014 13:52:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        jack.yoo@skyworksinc.com
Message-ID: <20141007125221.GG4609@sirena.org.uk>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1412658667-8196-1-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wZwWzkkm73dI25u3"
Content-Disposition: inline
In-Reply-To: <1412658667-8196-1-git-send-email-jack.yoo@skyworksinc.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v3 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wZwWzkkm73dI25u3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 02:11:07PM +0900, Gyungoh Yoo wrote:
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>

Several problems here:

 - I don't have patches 1-6 or the cover letter for this series - what
   are the dependencies?
 - I can't see any sign that my concerns about the driver not actually
   being reusable have been addressed here.
 - This patch appears to do way more than add a compatible string, for
   example:

> -	np = of_get_child_by_name(dev->parent->of_node, "regulator");
> -	if (unlikely(!np)) {
> +	if (!np) {
>  		dev_err(dev, "regulator node not found");
> -		return NULL;
> +		return ERR_PTR(-ENODATA);

--wZwWzkkm73dI25u3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUM+IEAAoJECTWi3JdVIfQYvQH/A6k+JAGfqKBx33HBmfSuDks
Tz/nTvj0KlH6/AB9rlUHZEl6pawKsVdKFYnWSZt4dIbHtQbVY96DgRM+OG+WiP2x
0W7/PBqg4nmXKWZbxQh9YhxBMXfdyoJEpkQhocqg5KWsb/6OAyxlb1Ba/O+dMQVJ
jtJix5+InoKTZLBX4zlQBPL7gp5ZcGRuMLbJSa7vmNRCdwwOu3pO2S5o+ZmUuYSp
lv8DywC3iS4ToFYI81b3aLtTkGobLp4bGBJTjuwpLI48GFt10aNl/Yd/WC4clb/m
lcz/LYjG5qf3tAFsUpG3gtEgOih27VjYRyE7ix5h1CSFZEvSyDJFt+fHcSNsAVA=
=hwNA
-----END PGP SIGNATURE-----

--wZwWzkkm73dI25u3--

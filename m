Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbaC0KzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:55:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33723 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaC0KzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:55:03 -0400
Date: Thu, 27 Mar 2014 10:54:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Xiubo Li-B47053 <Li.Xiubo@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20140327105436.GF30768@sirena.org.uk>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
 <11a8271c31044515bd2657a93aefdaec@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327023617.GB16197@MrMyself>
 <1e2d210764724c7e834c5307b54c37ab@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327025647.GC16197@MrMyself>
 <12f887b3889a41849026965f0cf7db1f@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327033117.GD16197@MrMyself>
 <62630844c7434df6937ca25d3f47b656@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140327035726.GA16359@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Content-Disposition: inline
In-Reply-To: <20140327035726.GA16359@MrMyself>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 27, 2014 at 11:57:27AM +0800, Nicolin Chen wrote:
> On Thu, Mar 27, 2014 at 12:06:53PM +0800, Xiubo Li-B47053 wrote:

> > I have checked in the Vybrid and LS1 SoC datasheets, and they are all the
> > Same as above, and nothing else.

> > Have I missed ?

> What i.MX IC team told me is SAI ignores what we do to FWF and FRF, so you
> don't need to worry about it at all unless Vybrid makes them writable, in
> which case we may also need to clear these bits and confirm with Vybrid IC
> team if they're also W1C.

And even if it payed attention I'd expect that a lot of the time they'd
just be reasserted immediately as the condition still holds.

--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNANpAAoJELSic+t+oim9r2cP/3dQQg6dU4Lij5ZiofJFGOjs
bQorzEeQzHbKAY4Wb305d0zLJXSP7jdZ30oczgm9NjeUh1MQQKuMhwKOAVLkhVMd
thCCEVltQiuFHvCFpg7FTjR6BJ+Zs0MHlCX9dRZ1Z9oukoqryqZA7bH7wu+7NKgp
P/TV+edn0XKXJ1O0JT2NOQTHdbiLedZjM1YwZorWCxPZI58YZ//0bKl5gU1S5PuL
huAYiuLHGMMzDF2RL+zBz+63LHbF6iuGHlQ3BdV/UTuakfijo/WEU23L94MOtydh
c3Idk9CZav/mfp3aKatlcabcYgrgOA248Ghmt9TSbNXQj8A+u6E1raA35YC2Yky8
J+tZ6ywqLpCqXjGDFK1B2GNMvdlBSLV9wFUINc3QHWtd0g8jpM5K/jVX8Pxh4bWc
tbnsrZ7LGAhNRmPtEOKNxOGMhaVULXE+M+BXmeG2+QUaZj6GK99BzkgpP/Oy2Kij
qb1II9xbGVAb2Kv6BgRWMx+vAlIQpamsdHDJhmyGqDoRXszQt1uW3Dv3M+Iz4S+N
lHZRbfwtNn6KbnaGzLL6Y8hNrEL5YkHBCzutO8Xj4JwILFXWzdCcd70OrE1CE9Tl
cOfbz/mF3pznrcuOl1cikhB7Zaz6V7LDhfi+aXNxa0eM1UCo87Ny/ESxt3n3dznO
+ws1n+FMe80NSiUqgDUr
=mDGu
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--

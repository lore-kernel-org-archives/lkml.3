Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbbANQeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:34:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57102 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbbANQea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:34:30 -0500
Date: Wed, 14 Jan 2015 16:34:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>
Message-ID: <20150114163415.GV4160@sirena.org.uk>
References: <857E9EDCA6C0904DB3357321AA9123EB0108B66919@NA-MBX-01.mgc.mentorg.com>
 <s5h1tmyiof7.wl-tiwai@suse.de>
 <20150113215412.GS4160@sirena.org.uk>
 <s5hr3ux24em.wl-tiwai@suse.de>
 <54B625A8.8090406@metafoo.de>
 <s5hoaq121gh.wl-tiwai@suse.de>
 <54B63E4F.2010506@metafoo.de>
 <s5hwq4phbzr.wl-tiwai@suse.de>
 <20150114120228.GT4160@sirena.org.uk>
 <s5hiog9h5xu.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OFtM20PmL5gDcvsL"
Content-Disposition: inline
In-Reply-To: <s5hiog9h5xu.wl-tiwai@suse.de>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is
 active case kernel crash
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OFtM20PmL5gDcvsL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 14, 2015 at 02:01:33PM +0100, Takashi Iwai wrote:
> Mark Brown wrote:

> > > Above all, disallowing the module unload while using is the common
> > > behavior of any other drivers.  Why do we have to be a rebel against
> > > all civil manner? :)

> > That's not true for everything

> Hmm, which driver does behave so intentionally?  I'm interested in the
> supposed reason behind it.

Relatively few of the subsystems in drivers have references to
module_get().

> > and for ASoC I'd tend to assume that the
> > user knows what they're doing and has a good reason for it; it's
> > certainly something that can be helpful in development.

> The module unload is never considered to be equivalent with hot
> unplug  It's more than that.

I'm not sure that's the case from a user perspective.

--OFtM20PmL5gDcvsL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtpqHAAoJECTWi3JdVIfQ2wsH/2+T+F7k18ei4Szp3Bv4Vf7h
Uv2T++/J/429RH+CJCNWrlr/l6NjtmZrICqqESvWI2kk4kwi+5AeAzR9nEIQ27sL
12LpBKaxsnSr9McgzlfdItIbypvfTMOV+ObUWK/RspBXWJG8mhxbp+wqG5EJ2jpP
dwejoePFskNGWgVVDw2GtK3vowLVP3musNeYbwsROWbNU9b0osCxRnm7lxrkHvhu
cPqOtaObE44dN4rZfRE9TUBJsGywlYsjP69RCSGM0jHrrvPo+aiG7ejjbVnZodwL
sG48T/lVpz6s3sHVALqT166oJzAkHmy5VS7w6te8aIzxWbomBNTPVWuGu1psUjo=
=bQ7Z
-----END PGP SIGNATURE-----

--OFtM20PmL5gDcvsL--

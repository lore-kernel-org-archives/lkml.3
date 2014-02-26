Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaBZLlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:41:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52191 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaBZLln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:41:43 -0500
Date: Wed, 26 Feb 2014 20:41:35 +0900
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140226114135.GC31120@sirena.org.uk>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
 <20140225085701.GD19099@lee--X1>
 <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
 <20140225115036.GF13246@lee--X1>
 <20140225121555.GB25940@sirena.org.uk>
 <20140225124050.GA7571@lee--X1>
 <20140225230721.GA2927@sirena.org.uk>
 <20140226093203.GK9195@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <20140226093203.GK9195@lee--X1>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 26, 2014 at 09:32:03AM +0000, Lee Jones wrote:

> > It can be worth doing anyway with a subsystem that's actively developed
> > since sometimees the dependencies are the other way - the APIs in Linus'
> > tree may have gone away.

> Then what happens if the tree that your patch finally gets sucked into
> is pulled before the one you've written your code against? I'd say
> basing your code on -next is generally a bad idea.

Submitters should defintely at the very least be checking against the
subsystem tree (since that's what they're really submitting against) -
it's always annoying when someone submits code that either doesn't
apply or fails to build with the current tree.

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDdLoAAoJELSic+t+oim9PpYP/3aod/odwRyNs0ok4abD5bhX
cd6DZX2ZhWuhoiU7T74MsF87R8AuDWRazh9UWsdOXfBrvi3kv8AMufQo3kxK2em/
eyeGfgNLYq87Fk6f5QdJGM2b3m7NLn+os+ttOF8/O2Z+suHBM3i1XzVOyAvS/URn
prSIXet604EfzAkEYvXLc7fv/QPH6CCs/4YcmhR5mkV8lpMXmS/Wx1RT3tBb9jgb
q2i6LrOY/HJRYTJtMVIqsfGfnmAUJu6T8tQ4aohUME7ca0Wxjlluqk/isAoKvW94
8gVWU33bThCCNpW25ONcxMNTjqcMzAdJeOIcf7oJkZpCB96TYqAqPyJ14RycRQuo
qCv1GYUjorIgvc9pwMrarT6GsDZXUtlrt5sjuf0LNhLsWIowNBHCZJNwzAVjnsYQ
3BpN6rSsha8uKm3MQr63fC0NcR+WxLReZRF750wXLNRLW/qB6acube7QA+H52OYZ
Hr+4KbaCTgW4eFzUwuHufKnkySnzMqVdPMaygaheSWNpBqeXFhoeWD/dsCakX65Z
MvbyWMA4Bns2Y+dzj7Mtdza/5rKyHS6mlfUFO1W2d8tpuTpBIQzBYxHW38AvaOXM
FfyXh54Qcdv9CZiSAReChjb6QwwMWdL+HPEWBPO+fpmvXOGENL/GbHO8/5npjfoR
0acgh2R/aLFeEOI9AySy
=wP26
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--

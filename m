Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaHKGgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 02:36:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:5467 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaHKGgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 02:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="370713009"
Date: Mon, 11 Aug 2014 11:54:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v3] ASOC: dapm: add code to configure dai
 link parameters
Message-ID: <20140811062429.GC13288@intel.com>
References: <1407341786-14990-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
 <20140807141604.GJ8181@intel.com>
 <20140807171324.GM17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <20140807171324.GM17528@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 06:13:24PM +0100, Mark Brown wrote:
> On Thu, Aug 07, 2014 at 07:46:05PM +0530, Vinod Koul wrote:
>=20
> > I was thinking about this as well a while back, wont it make sense to l=
et
> > machine driver expose meaningful controls for this. Just like we have f=
ixup
> > for back-ends, we can add fixups for codec-codec links and let machine =
tell
> > you the parameters to configure.
>=20
> This is supposed to be pretty much the same thing (not looked at the
> patch yet) - the machine driver passes in a list of possible settings
> and then a control gets generated allowing the user to pick one.
Yes but this is bit different from the current way of using fixups for BEs.
So it would be bit incosistent. For pcms it would be only fixups and for
loops it would be machine controls

--=20
~Vinod

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT6GGdAAoJEHwUBw8lI4NHO10P/jLg7pbaz5115CPquENsYLcL
CIBTMl+9iwMijhWUDMouyzXwfo93G4apWZy8mEO9EE9E3s+lNhs2cyoQq+e/ots/
/dxRRyPG+m9n8JRYQRf0IjE1JTXZLYcksEzXyhZxv30bPvI7N1v4KQAz1vynCX2g
QNhVkyT7ot9oXIPRNL2fn8Hfbr93oTHGdnICf3XJLeJlBC8BpWRbcOnqtOHDVvLs
yr25JYzqTCGSScNgWsMddQ0yiBpl6NRsRd5zhBMQKXRJX5l6gubYVWJgjr5QriSt
d0V61rP5YKos+1maPmbJKUxK19TO5OsTSz1Gaa6C26JV8PSl8AVrwL00BGsWUvMO
XE6rSCER4pgzf/oC3D4vF+OqLS+VQvWKuKjLG/uCArUU2CWn2OXDpeXpu8pqsciN
cPwq8vE6pzWzFKDJONRLqh6PNhoKFlruyphio4bdvHYLDJDCo4l6GmUFFRp0AOVC
muvarb5suc3PdAqgOuUcAMjtifY+aMIu8HFAaXYxAKDQzcIhQuUPaziDjgvUH2hu
GTPXUbmc5lcQV85bMXmktBC6MUG9//mIwm0ywtTYGeIsHZoYg1zqZN3IezNuKylr
apWGfHN6W9vYM0bEWMGMyd89TOwLNDzF3uzL/d7vMswNSx9ow1m81L/1kVExBd+v
D/jLrbcIFGe3eVlZZRRW
=HjRZ
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--

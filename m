Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaHKMTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:19:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58031 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaHKMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:19:29 -0400
Date: Mon, 11 Aug 2014 13:19:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140811121912.GY17528@sirena.org.uk>
References: <1407341786-14990-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
 <20140807141604.GJ8181@intel.com>
 <20140807171324.GM17528@sirena.org.uk>
 <20140811062429.GC13288@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7GWBejRy/Pz6SUcf"
Content-Disposition: inline
In-Reply-To: <20140811062429.GC13288@intel.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3] ASOC: dapm: add code to configure dai
 link parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7GWBejRy/Pz6SUcf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 11, 2014 at 11:54:29AM +0530, Vinod Koul wrote:
> On Thu, Aug 07, 2014 at 06:13:24PM +0100, Mark Brown wrote:
> > On Thu, Aug 07, 2014 at 07:46:05PM +0530, Vinod Koul wrote:

> > > I was thinking about this as well a while back, wont it make sense to let
> > > machine driver expose meaningful controls for this. Just like we have fixup
> > > for back-ends, we can add fixups for codec-codec links and let machine tell
> > > you the parameters to configure.

> > This is supposed to be pretty much the same thing (not looked at the
> > patch yet) - the machine driver passes in a list of possible settings
> > and then a control gets generated allowing the user to pick one.

> Yes but this is bit different from the current way of using fixups for BEs.
> So it would be bit incosistent. For pcms it would be only fixups and for
> loops it would be machine controls

That doesn't mean it's the best way to go in the end though - long term
I expect to see us move away from that to something more data driven and
DAPM integrated.  Requiring drivers to open code things rather than
factoring out the code doesn't seem like the right way forwards.

--7GWBejRy/Pz6SUcf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6LS9AAoJELSic+t+oim9ePEP+gN40rIzGUUFzVUWvY9BySgJ
FJkXpoLJR7GWmVdWlcWYOy3ehOTTMzJvv5UwGCpzfKFQEwqvw2817kyaeq0Z+7Sx
K9LnCXpZLgeq+hjULi5qLNzKvj+ur5iUtIkuG7y2ZXszOraSL4acA5DVBkXxMdOA
noY58Y6nwVDGgwOi0X+sF9Z7PiUK7pTpBNT/sYulm/LbOxEVq13Wf2WzLUmxMyB6
r/3+IS8ReP77BiNiuWJu0YDpeQt7xOqt2FQQleTUM9mlAexvP2GWjCWN1bTpTu0u
VCTt9HodU299Bug3YEdR81gRUZTFXgdHkPZLGe6/a5TlkFEc+HakEu7HKOyUVKpu
imnl3I9pMS4RDSw7ZU1AGFhWfGHrEgvCWYiXx3J5y9iv3Z7Ix4mp5uP3pJOyQPfJ
IUuvarMYajlCt1qWaRWxbDmGd60ovwBRKjmaDpmWa48DhfoEoXD7y3ayVEVnn3Ir
gK+6eZKG5IbqQaJ/0gPK4XEnETMF3jXTjGfOApJKpAfhNMry8fC2LWIaNvZgWNhG
fI61kzFvFNFuaAigUK2qKEDOFy34oCXLGMuSiClJNbet7cvgorFoj92vto+DZ+rZ
JMIfa0FKk6IT9pLhMgpN6+QZW39dSeifYXok1PA1TNvhW3lFyAUtTtuzFfodE0++
/cs7lNWrcuha8qSEmSwD
=3Rhm
-----END PGP SIGNATURE-----

--7GWBejRy/Pz6SUcf--

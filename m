Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaHLPXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:23:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:11995 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaHLPXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:23:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,849,1400050800"; 
   d="asc'?scan'208";a="575611602"
Date: Tue, 12 Aug 2014 20:40:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v3] ASOC: dapm: add code to configure dai
 link parameters
Message-ID: <20140812151014.GF13288@intel.com>
References: <1407341786-14990-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
 <20140807141604.GJ8181@intel.com>
 <20140807171324.GM17528@sirena.org.uk>
 <20140811062429.GC13288@intel.com>
 <20140811121912.GY17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <20140811121912.GY17528@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 01:19:12PM +0100, Mark Brown wrote:
> On Mon, Aug 11, 2014 at 11:54:29AM +0530, Vinod Koul wrote:
> > On Thu, Aug 07, 2014 at 06:13:24PM +0100, Mark Brown wrote:
> > > On Thu, Aug 07, 2014 at 07:46:05PM +0530, Vinod Koul wrote:
>=20
> > > > I was thinking about this as well a while back, wont it make sense =
to let
> > > > machine driver expose meaningful controls for this. Just like we ha=
ve fixup
> > > > for back-ends, we can add fixups for codec-codec links and let mach=
ine tell
> > > > you the parameters to configure.
>=20
> > > This is supposed to be pretty much the same thing (not looked at the
> > > patch yet) - the machine driver passes in a list of possible settings
> > > and then a control gets generated allowing the user to pick one.
>=20
> > Yes but this is bit different from the current way of using fixups for =
BEs.
> > So it would be bit incosistent. For pcms it would be only fixups and for
> > loops it would be machine controls
>=20
> That doesn't mean it's the best way to go in the end though - long term
> I expect to see us move away from that to something more data driven and
> DAPM integrated.  Requiring drivers to open code things rather than
> factoring out the code doesn't seem like the right way forwards.
Okay if that is the direction then this sound good to me.

Only one last nitpick on how do we set different format value apart from
sample rate, bits etc here. We have devices talking on same port and each o=
ne is
different format(one use i2s, one uses tdm ...), so how do we handle that p=
art?

Thanks
--=20
~Vinod

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT6i5WAAoJEHwUBw8lI4NHAWsP/j3ydOPQ3XwGowejZTAM52aM
3CKrTg7m4VJ49iRU3AVI4eBfbsiM1V63XqFyNVGH76JO1QvvVAfvyajshBS096Ww
Mxpc+5k81f0dktw+/WZer28oV+aVUPmgAitnfJb4UsAzDXfqB1/yEYfIcxBPv3Ro
GJNTBbw4VvWIF1UShdV004GXwbnxGmsgqQfSo26Ss+UBbRHnil09woR5x0tU9wum
o+/pP3aWz4vV/793Nf5p1ul02pAzV8VvLbM5izdhcW+amTeXfKlmbk5Jmjde6GSN
zl0nmw0TOvIupKPJHYnZCzoZbYP7XU2+iY+NSg5kVKMlZZpAASSSyV6KwcOQKL6j
wUN90Y9KV+67nPzZFZsyydQJMFT5Z7aOfCdbIx3BXMfJ5rvG6wb4sYhF/+rcK3FR
OintusMzZBpzE6gF92otx3vA9mfIYd6MPlg7vrkXkvnFLUHQfR7NdUfRpbMqzTJx
ydbxYifPbEzixE0pN7wX+N9wvGsAMUzXjPPqViKXMoJucGB8rx8Vp3mWuIZSuEJ0
iXIoUj02H/6XorjqqZ3/QEa6uyqeRO3X2p0wL21z6hTYLZpkULTKVXNAtwZaBHPZ
AOdMsUbUFQcM41ptdbt3yUW5LiuWer8Y/0ud5Jh+JlZkpkJh+tSShtno6dk/Vi88
s/vavcApeUYGCPXgIozO
=Dk81
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--

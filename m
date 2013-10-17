Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3JQOYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:24:00 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41726 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab3JQOX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:23:58 -0400
Date: Thu, 17 Oct 2013 16:21:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: [PATCH -next] misc: fix various misc/mic/host/ build errors
Message-ID: <20131017142138.GC32734@ulmo.nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C481E.1010908@infradead.org>
 <20131016192648.GA19637@kroah.com>
 <525EEBD4.7070800@infradead.org>
 <20131016194440.GA14416@kroah.com>
 <20131016203024.GA6579@mithrandir>
 <20131016203727.GB1633@kroah.com>
 <20131017140224.GA32734@ulmo.nvidia.com>
 <20131017141629.GP2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <20131017141629.GP2443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2013 at 03:16:29PM +0100, Mark Brown wrote:
> On Thu, Oct 17, 2013 at 04:02:25PM +0200, Thierry Reding wrote:
> > On Wed, Oct 16, 2013 at 01:37:27PM -0700, Greg Kroah-Hartman wrote:
>=20
> > > Yes, I'll do that as part of my normal tree submission process.
>=20
> > Actually, ensuring correct merge order won't be enough, will it? That
> > doesn't magically fixes that the function's signature actually changed.
>=20
> > Shouldn't the update of the sysfs_get_dirent() call be fixed within the
> > same patch that updates the sysfs_get_dirent() signature?
>=20
> They're applied in different trees so they're both OK by themselves,
> it's the merge that brings the two together that needs to do the fixup.

Right, as long as the person doing that merge remembers to do that. It
sounds like the thing that could easily be forgotten. But Linus has been
doing this for a long time, so I'm sure he'll know what to look for. I'm
curious though, are maintainers supposed to mention it when sending pull
requests with such a dependency?

Thierry

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX/JyAAoJEN0jrNd/PrOhnmIP/2SY2aemSZjdn0LSPBQsTFv5
7/jfGlSkGhWvrRY3shIxe5KQ0BW0uJj7VaHB4hq+SRcgT08iEZdukjRJRLUacUpt
jPFxFV/qQWtdGU9FZr3DL4O3p0KHQ9R69XHMYx+bZ6GqpQ49UMrjJZyVPq2TWVXx
8sl//0jVMGoGegZIxSEnqGxjIz57W8sVQ+gNbhiF78AGbLrE23uydZdljA+gZ6VF
vse2GPaAM0h0Ryycf6uprBaHcNbAjPOIQmaUcM1hTpib10x/EvtHL53ySs/SIhJV
Cgjuwy/M3OnBnc+86R3545er0+yakWLjxg/jpC+iyIqgwyg7kCJ7gKpr+afMzHUW
C2XscCrk50xDcXAq73/iVJLwZcE7qyjUVex/27iLfyFG35UrvoZagnSQThb6ux9Q
3GA3vXtjkSkNBLmQWuArJ3LUJ/PVsaePjs6GUIB0L4048bqbRjQueoAn4HeCOD6H
zeZ9TsMGwQgcog2WcvsO03SS4H1kXrBLcSpZen/tw1/Hbluzp2FyeezzmbOYweq4
83ynjN0BHTxAuZ92I44tE/sTW4gC6k/w9NFilV4vPKRDBtffPzNnAQteTMKTtQTt
u8TdFcO2y+yEhFZJ8BkXuZzuaXgO0XOpJJJGOnRiLU4UW7ayZ5rnIZHs/4XhMYWh
sN6iS6SRTagfkALlxYnl
=BDyC
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--

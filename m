Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaDVR6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:58:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850AbaDVR6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:58:20 -0400
Date: Tue, 22 Apr 2014 19:58:18 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Alexander Aring <alex.aring@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org
Subject: Re: [PATCH 1/3] 6lowpan: add helper to get 6lowpan namespace
Message-ID: <20140422175818.GN27882@wotan.suse.de>
References: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com> <1397784176-15809-2-git-send-email-mcgrof@do-not-panic.com> <1398159886.4211.1.camel@jlt4.sipsolutions.net> <20140422095300.GA9241@omega>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EemXnrF2ob+xzFeB"
Content-Disposition: inline
In-Reply-To: <20140422095300.GA9241@omega>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EemXnrF2ob+xzFeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 11:53:03AM +0200, Alexander Aring wrote:
> Hi,
>=20
> On Tue, Apr 22, 2014 at 11:44:46AM +0200, Johannes Berg wrote:
> > On Thu, 2014-04-17 at 18:22 -0700, Luis R. Rodriguez wrote:
> >=20
> > > +#if IS_ENABLED(CONFIG_IEEE802154_6LOWPAN)
> > > [...]
> > > +#else
> > > +static inline struct netns_ieee802154_lowpan *
> > > +net_ieee802154_lowpan(struct net *net)
> > > +{
> > > +	return NULL;
> > > +}
> > > +#endif
> >=20
> > Why would that be needed? If nobody compiles 802.15.4 then it seems
> > nothing should reference it?
> >=20
> Indeed I think this is unnecessary, also.

I wanted to be sure, and I was not. Right now 6lowpan does not depend
on CONFIG_NET_NS, is this intentional? I think its fine without it
but I was not sure.

  Luis

--EemXnrF2ob+xzFeB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTVq26AAoJEPep4JnvMe6zdF8P/i5ERmEO5yxPrcpRwJuOn+UV
H3GInw94Q7rqvTKna+fSZ4UWqB+DSZKSmEbHXKRk1ClLfpDNj2eP/k//cDdJrKJg
veYWp3Sbng8qGvvqPVGWnzJGJfXCSUrBYFpNy9+SGpxkBPLTqm6IlB0HC3a+mxwm
n+mvjVp6SNPEdNWVPCjspFM7QkVDeMw3Xbr5Kg9Q5/z0xahzfw1GaSdgJ3jer/84
lvtEdiImRq7G89FrGcDXxiHpzowOOnncuxPj4KuMz+DTKa2IBCtflBI9flfo+i6D
fK/pgw+ftQR/x7kt/Lj8gU7DYlVibsb/idirPTFHgKrqtsIU0guX0iX27nwMjm5X
D2P+/ZBfS4GFFmjW1UTxUKLk92NqaVv//i+te6SQLWS6N6pIojBxOTYnleG/UQgz
CPF7dTSUlViY2HA3QCIyjPa0PYzWOHMS7ZnvisPoVtxrr+OHCeMoGcXCmUEKrLda
xB+jXA/PkT1kOJ1tghAFW2xpilVHY4ppNH9oZnnI3q93doKX1kLS1wcFSumo1+bc
TrXmOmwav6VMgoz3AIHEgLr7/WcisPjHAO4EcEpIoiKkerMQT9PyqvkoTuYDnajt
K7Kuk8eFSHh45S2vf4dF+0ErMHoX8hubWUtQUssjPwZOUiFcqtLkwfqZYOZEdKte
Ot7NN2/6VeLiAa3uA2AZ
=UZIb
-----END PGP SIGNATURE-----

--EemXnrF2ob+xzFeB--

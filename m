Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbaIRSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:16:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59244 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaIRSQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:16:39 -0400
Date: Thu, 18 Sep 2014 13:16:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the vfs tree
Message-ID: <20140918181630.GG4537@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140917161658.2e4eb3f1@canb.auug.org.au>
 <20140917153400.GA8140@saruman.home>
 <20140918171226.GE4537@saruman.home>
 <20140918180921.GA7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <20140918180921.GA7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 18, 2014 at 07:09:21PM +0100, Al Viro wrote:
> > > > Today's linux-next merge of the usb-gadget tree got a conflict in
> > > > drivers/usb/gadget/function/f_fs.c between commit 8322215aa91c ("f_=
fs:
> > >=20
> > > I can't find this commit on linux-usb. In fact, googling for it the o=
nly
> > > reference I find to that commit is this very thread. I would strong
> > > suggest that it be removed from the tree as it, apparently, went in
> > > without any review. Sure, it's a simple change, but it needs to be
> > > reviewed and needs to be sent to proper maintainers.
> > >=20
> > > Unless I'm missing something, of course, but I could not find any oth=
er
> > > references to this commit.
> > >=20
> > > Al, was this commit sent to any mailing list ?
> >=20
> > a gentle ping here
>=20
> <looks at #for-next>
>=20
> Oh, bugger...  I see what has happened - there's a local queue with a lot
> of pending cleanups; this (and several around it) got into the wrong queue
> and leaked into #for-next.  My apologies; I can certainly take this stuff
> out.  It is an obvious patch, and the only reason why it's there at all
> is that it's a part of preliminary cleanups for sorting the
> d_add/d_splice_alias/d_materialise_unique/d_instantiate/d_add_unique
> mess out.  That almost certainly will be a part of the next cycle, in
> the first place, and this particular commit isn't even a prereq - it's ju=
st
> something that fell out of grep while sorting out the calling conventions
> for those guys (what's locked, what is or isn't hashed, etc.)
>=20
> So I've no problems whatsoever either with ripping it out of -next and mo=
ving
> it to the local queue until the next cycle, or throwing it your way and w=
aiting
> for it to hit the mainline.  Both f_fs and gadgetfs commits should go your
> way, right?  Just tell which way you prefer them handled...  Again, I had=
n't
> planned to push those; there's no reason not to, but they can certainly s=
it
> around for longer.  Sorry about the mess...

Hey, no problem. At least now we know it was just a mistake. If you can
just add my Acked-by: Felipe Balbi <balbi@ti.com> to both gadgetfs and
f_fs, I'd be very glad.

Thanks for looking into it.

cheers

--=20
balbi

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGyF+AAoJEIaOsuA1yqREfOgP/3e+7Rt4Z6R/EBmjqk+D+Wax
SycsSi3aUQQlPA643rzaGskrZnZeQ87EWNGrVlCoOHbpnRkLq/niMh8nwfgMJdm8
5U/x2/4svtoNq0vg9DBijjHSvjW+ZLOgCbK3+Gx0aZg1npKhpZOkOVYIOQsYKdjc
wNjgzVKbyVRr8QXulmRwZemliChTwtCUJc/Kl1+v0DAYJfGf2FlIatj3wCG4hn6w
4FkA8TTKcp76OHX92Idb8srZ+7pu69GQ7F5toDKYysarWfUYcOoeEO4BFpTt9yWv
77qpTmWYhxBCjVM2JcBlqlRwngPKAH/zH3kdREt5W2mpXd1cZfzylsVL8hQfHYrQ
p3qgqROOFD/NCZCBSUtb/imvRARpe8YoBm5S9jGbUH+KCztTSTmsVGJpcMpLhVHk
wqM9cnXssrSWMQABiUu1kfyV7sXbwdE7Cip7CD1/1vvXhg3Yg7GnErxfPg8Nopyk
/ZIO2trN3GnKmBQeBLSX6SLfGG0cnIiyeO/+BwW4uauE79S3lEo2ijfrQK9cNMG7
G/3bwPAPZMGoBU79vgDfCVLpE3ob+9TyANJniOGEJ+9DoNnsHsHK5BMAXbIWAMJI
vE1Y9oLDAfy5rtd090x/qji/SH0u8N+NSaDVZPCFdeRyJaNrtE7+NMKHY16Q7fLA
/Z9Xf0cyERTwZ8dFnVrH
=mIfa
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--

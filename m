Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaHANRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:17:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:53292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaHANRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:17:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,780,1400050800"; 
   d="asc'?scan'208";a="463977998"
Message-ID: <1406899019.11706.9.camel@intelbox>
Subject: Re: [Intel-gfx] [BUG?] 3.16-rc6 ... at
 drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12d/0x160()
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Date: Fri, 01 Aug 2014 16:16:59 +0300
In-Reply-To: <1406843268.6143.1.camel@gmail.com>
References: <1406158393.13064.1.camel@gmail.com>
	 <1406280517.17325.3.camel@intelbox> <1406753579.31042.1.camel@gmail.com>
	 <1406806772.18327.14.camel@intelbox> <1406843268.6143.1.camel@gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xPYLAU7Ac22dt/rbrQug"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xPYLAU7Ac22dt/rbrQug
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-07-31 at 23:47 +0200, Ian Kumlien wrote:
> On tor, 2014-07-31 at 14:39 +0300, Imre Deak wrote:
> > On Wed, 2014-07-30 at 22:52 +0200, Ian Kumlien wrote:
> > > Sorry for the delay, it's been damned hot - vacation is over and
> > > overtime has been all the rage at work...
> >=20
> > No problem, thanks for the feedback.
> >=20
> > > On fre, 2014-07-25 at 12:28 +0300, Imre Deak wrote:
> > > > On Thu, 2014-07-24 at 01:33 +0200, Ian Kumlien wrote:
> > > > > Try four, now including CC lists for the intel driver...
> > > >=20
> > > > Could you give a try to the 2 patches at:
> > > > https://patchwork.kernel.org/patch/4437061/
> > >=20
> > > Didn't quite get that it was two separate patches at first, but when =
i
> > > did i also spotted a v2 of the patch set.
> > >=20
> > > I applied:
> > > https://patchwork.kernel.org/patch/4648961/
> > > https://patchwork.kernel.org/patch/4648951/
> > >=20
> > > On to 3.16-rc7 (there was some fuzz but it applied fine)
> > >=20
> > > I didn't see any OOPS:es (didn't scroll around too much) but otoh the
> > > screen never turned off? (it's one of those silly mac things, the app=
le
> > > is still lit) and the machine doesn't "suspend/sleep" anymore.
> > >=20
> > > AFAIR it does, after some coaxing, on the unpatched kernel (ie, not t=
he
> > > first time but the second time i turn down the lid, i tried three tim=
es
> > > and play:ed with brightness as i assume you can see in the log)
> >=20
> > Hm, I can't see how these patches could prevent system suspend. Also
> > according to the dmesg you sent suspend didn't even start, so I guess
> > you're seeing a separate issue. Maybe the lid notification isn't
> > properly handled, but I can't really help tracking that down.
>=20
> It works without the drm.debug=3D14 so it might be something else...=20
>=20
> > In any case to reproduce the particular bug in question (or see if the
> > fix works) you need to get the machine to suspend/resume somehow. One
> > way is to 'echo mem > /sys/power/state' as root and resume by pressing
> > power button or similar; could you still try this, again sending the
> > dmesg?
>=20
> You'll find it attached ;)

Ok, I see the trace of suspend/resume now, but the bug has vanished.. I
can't see the WARN backtrace in your original report, nor the debug
message from the above fix, that would indicate that it had fixed
anything ("VDD left on by BIOS, adjusting state tracking"). So I'm a bit
lost, I would need a full dmesg with either the WARN or this debug
message.

--Imre


--=-xPYLAU7Ac22dt/rbrQug
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJT25NLAAoJEORIIAnNuWDFdnkIAPQY1gLS1qJshY4TSz+c8uz5
VXp5KZ9hgFWPjdwGdmivOn27M6htKX76C72E5+cYHwCqjCPnfCRR4S82AIppJxlg
deOk6sGP8HYH/Yn5krxcTKwZW3fjO8v9fZzRCPcIZdur+2W0uXHUkxUQZA0WHAn+
v2vwoxsI4maHjfiuNv7GJE1AtrVxL66bla6c2A3XjU6mI8yhxhUocewmr70aiibP
nA9atSi8+TCCloC9DsYTvPuYqKD5E7B5TcdfgTT6FQUxaBZrjeZikbZj+Ib43lJp
BRW1gs4YPPmLrcCXo/g/RJRK2b2uoZvC9kL7K5h+tbWcGF8rcbzIxvJ9xcKyMvA=
=fp4u
-----END PGP SIGNATURE-----

--=-xPYLAU7Ac22dt/rbrQug--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaFNE44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 00:56:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59618 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaFNE4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 00:56:53 -0400
Date: Fri, 13 Jun 2014 23:56:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Felipe Balbi <balbi@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Message-ID: <20140614045603.GA28775@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-2-git-send-email-balbi@ti.com>
 <20140613162323.GH8319@saruman.home>
 <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
 <20140613231019.GA24121@saruman.home>
 <alpine.DEB.2.02.1406140127020.20370@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406140127020.20370@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jun 14, 2014 at 02:57:32AM +0000, Paul Walmsley wrote:
> > > > > From: Sathya Prakash M R <sathyap@ti.com>
> > > > >=20
> > > > > Add DSS hwmod data for AM43xx.
> > > > >=20
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > > > > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > > > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > > ---
> > > > >=20
> > > > > Note that this patch was originally send on May 9th [1], changes =
were requested
> > > > > and a new version was sent on May 19th [2], then on May 27th [3] =
Tomi pinged
> > > > > maintainer again and go no response.
> > > > >=20
> > > > > Without this patch, we cannot get display working on any AM437x d=
evices.
> > > > >=20
> > > > > [1] http://marc.info/?l=3Dlinux-arm-kernel&m=3D139963677925227&w=
=3D2
> > > > > [2] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140049799425512&w=
=3D2
> > > > > [3] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140117232826754&w=
=3D2
> > > > >=20
> > > > >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++=
++++++++++++++
> > > > >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> > > > >  2 files changed, 99 insertions(+)
> > >=20
> > > Sorry for the delay on this.  Have been corresponding with TI managem=
ent=20
> > > to figure out what to do about patches for AM43xx.  I don't have boar=
ds or=20
> > > public documentation for these devices, so it's impossible for me to=
=20
> > > meaningfully review the patches.  Looks like boards and/or public doc=
s=20
> > > won't be coming any time soon.
> > >=20
> > > So for my part, here's what I'll need to merge any hwmod or PRCM patc=
hes=20
> > > that involve AM437x:
> > >=20
> > > 1. A Reviewed-by: from one of the following folks (which should come =
=66rom
> > > a different person than who is submitting the patches):
> > >=20
> > > Roger Quadros
> > > Nishanth Menon
> > > Rajendra Nayak
> > > Kevin Hilman
> > > Tony Lindgren
> > >=20
> > > 2. A Tested-by: from one of the following folks (who can be the same =
as=20
> > > the person who is the same as the person who is submitting the patche=
s):
> > >=20
> > > Nishanth Menon
> > > Rajendra Nayak
> > > Kevin Hilman=20
> > > Tony Lindgren
> >=20
> > What you're saying here is that it's pointless for anybody else in TI to
> > review and/or test patches because you will only accept such tags from
> > this list of 4 ~ 5 people.
>=20
> That might be how you interpreted the E-mail.  But that's not what was=20
> written.

of course it was. Read what you wrote:

"here's what I'll need to *merge* any hwmod or PRCM patches that involve
AM437x".

That basically puts down the requirements to getting any patches
accepted and those requirements are the blessings of a handful.

> For the record, I'm pleased to accept Reviewed-by:s and Tested-by:s from=
=20
> anyone.  But, like most maintainers, there are some folks who I think do =
a=20
> better job of reviewing and testing hwmod and PRCM patches than others.
>=20
> The people listed above are a first cut at that list.  I'm certainly
> happy to consider adding others, but the reviewers need:
>=20
> 1. to have experience with those parts of the kernel;
>=20
> 2. to have access to the canonical documentation for AM43xx to review
> against; and

anybody in ti.com have access to those.

> 3. to have some kind of track record doing in-depth reviews of patches
> for that subsystem, or writing clean code for that subsystem.
>=20
>=20
> Similarly, for testers, the folks listed above are people who:
>=20
> 1. could actually have AM43xx boards; and

well, quite a few have rather easy access to multiple (3, to be exact)
different am437x platforms.

> 2. who have a history of testing patches against mainline kernels in=20
> public forums, rather than testing against vendor kernels; and

$subject and patch two have both been tested on top of linux next from
june 10th. Is that bleeding edge enough for you ? Moreover, *only* these
two patches were applied on top of Stephen's linux-next.

> 3. who I think would be mortally embarrassed if a patch was broken=20
> that they had a Tested-by: for.

right, and when those guys try to get bugs fixed, we spend half a year
discussing pointless might-happen-when-the-sun-dies problems with other
drivers even when... aaaah what the heck, you'll just say I'm mixing
threads again...

The point is that it has been this back and forth for quite a while now,
in countless occasions we have missed merge windows because this or that
maintainer just stops responding and *nobody* else has balls to pick the
patch up.

Weeks later social network posts start to arise blaming TI for not
sending patches upstream.

> (N.B. In the case of anything involving DSS, such as this patch, I'd be=
=20
> happy to accept Tested-by:s from Archit or Tomi.)
>=20
> If you have other people that you think I'm missing from the above two=20
> lists, who meet those requirements, please suggest some names!

the point is about not having a list. Sure, you need to know some folks
who you can trust, but sometimes, when it's clear that the patch doesn't
break anything, follows standard code practices, have passed through
more than one hand and soaked in the mailing list for months, it's time
to give up and just let the patch sit in linux-next for a while. You can
always revert if someone else starts to scream.

I'm *not* saying that you should blindly accept anything, but not
accepting patches without a reason isn't fair.

> > Quite frankly, it's very upsetting to see an affirmation that all the
> > work that I (personally) and many others do is seen as "pointless" from
> > your side *unless* it gets the blessing from the few folks listed above.
>=20
> I'd be curious to know how many of the people listed in the Signed-off-by=
:=20
> for these patches have double-checked the data against the TRM (or=20

I know I've done it. Have latest am437x Datasheed, TRM and board
schematics open for quite a while now as I've been hacking this am437x
StarterKit.

Also, the thing is functional. Xorg + i3 runs just fine without any
glitches or bogus colors, or any sort of warnings, errors, anything at
all.

> whatever documentation is canonical for this chip).  And have thought=20
> through whether the data actually makes sense with regards to the SoC=20
> integration.  I consider those to be the prerequisites for reviewing hwmo=
d=20

how else would we get the freaking thing to enable clocks ? Or are you
forgetting that long ago the entire OMAP architecture was made tightly
coupled with runtime PM and HWMOD; and are you also forgetting that no
driver is now allowed to call clk_get() directly without hurting
somebody's feelings ?

With these details in mind, there's no SoC who depends on mach-omap2
that can have any chance of *working* without hwmod data.

> device data patches.  That's what I generally do myself, and that's what =
I=20
> expect from trusted reviewers.

alright, so do you see any problems with the patch ? Do you think the
data isn't necessary ? Instead of just being silent for months, why
don't you just drop a line ? Reply to the f-ing thread ? How can we make
any progress if you don't ? Is this what we have to go now ? Send a
patch and hopefully, some day, it will make its way to mainline ?

> > This just makes it ever more difficult for anything, which is clearly
> > *BROKEN* to be fixed upstream and will just contribute to people
> > vanishing from mainline development.
>=20
> Sounds like you might be mixing mailing list threads. =20
>=20
> The description for these patches states:
>=20
> "Add DSS hwmod data for AM43xx"
>=20
> Unless I'm missing something, these patches add a feature.  They are not=
=20
> fixing something that is broken.

without DSS hwmod data, how can display work ? So it _is_ broken indeed.
The same DSS code is functional in many other SoCs, but it's *broken* in
am437x because $subject has been pending without *any* reply since
May 19th.

> > The very fact that you will only accept patches blessed by the gang-of-4
> > goes against the very foundations of open source development. Just
> > because you don't have access to documentation - and granted, that
> > _does_ make things a lot more difficult - does not mean you have to
> > consider an entire company as a non-trust worthy organization. Specially
> > when there are so many here who have been doing mainline development for
> > quite some time.
>=20
> As stated, I'm happy to consider adding more folks to the list, but they=
=20
> need to have a track record of doing good work in that area, or doing=20
> in-depth reviews.  If they don't have one yet, well, there's no better=20
> time to start than the present.
>=20
> I'm also happy to do the reviews and a basic test myself, if I have=20
> documentation and a board.
>=20
> > It doesn't take a brain surgeon to note how this won't scale and, if yo=
u=20
> > continue to ignore patches during the entire development cycle and only=
=20
> > reply after it's too late for $this merge window, it won't help much.
>=20
> ...
>=20
> > Anyway, whatever... I just hope that if we go through *another* merge
> > window without $subject being merged
>=20
> What is this business about "*another* merge window" and "continue to=20
> ignore"?  Using the dates from your own E-mail message above, the origina=
l=20
> patches were sent May 9th.  This was the same day that v3.15-rc5 was=20
> released. According to your message, the revised patches were sent May=20
> 19th - three days before v3.15-rc6.

right, right.. I'm talking in general. This *could* have made it into
v3.16. There are also other patches which were missed. One of them since
january.

> So by the time these patches were ready to go, we'd already reached the=
=20
> cutoff point for getting anything merged into v3.16.

not really. We had 3 more tags (3 more weeks) until v3.15 final was
tagged. Add to that the fact that the merge window is 2 weeks long, 4
weeks (leaving the last week as padding) seems like enough time.

> I was rather hoping that I'd be able to review it against the AM43xx=20
> documentation in time, but that turned out not to be available.
>=20
> If all this has nothing to do with the $SUBJECT patches, and is about the=
=20
> DSS clocking issue, and not these patches, that's fine; but please direct=
=20
> your flames to that thread instead.
>=20
> > ps: $subject in particular, has been tested by 3 different people.
> > Actually 4, if you consider Darren Etheridge who used $subject to help
> > me get display working on AM437x SK.
>=20
> There are no Tested-by:s on this patch.  It seems likely to me that Tomi=
=20
> has tested it against something close to mainline, just based on general=
=20
> experience with his level of patch quality in the past, but in general, I=
=20
> have no way of knowing this.

SoB usually means the patch was tested by that person. Or are you
implying that neither me nor Sathya (patch author!!) ever tested the
patch ? I can post a video on youtube if that makes you happy, but boy
do I want to avoid doing that...

> So if folks actually tested it against mainline, please do send=20
> Tested-by:s, and note the mainline commit that it was tested on, along=20
> with other patches were needed for this patch to apply and/or work.  It's=
=20
> also helpful to include a serial console boot log to a Tested-by: message=
=2E =20
> That adds confidence that the patches don't add extra warnings and that=
=20
> the commit ID is what's expected.

sure thing, but don't expect everybody to just figure out what's going
on inside your head. Silent gets us nowhere.

> For the specific case of this patch, since it's already been reviewed by=
=20
> Rajendra, once there are good Tested-by:s sent to the list, I'd say it's=
=20
> ready to merge.

good Tested-by:s ?

nice

--=20
balbi

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTm9XjAAoJEIaOsuA1yqREiD0P/1F3KQl/ibZafdDOdQjy8OTP
Ref80xXzzjgEGNAMhZ8EZhYLvOv+AI/4qXiV52HG0/9WzjVNs2BJff7kQDxTRtoh
iz67QvWctxm/vL0rP2sFwgOj3BUDEzWNra8Ty65rNwbHkeBSAd4H0BXv10dGUI59
meP156jwplaE4HYgW1kJXU2M/xGwgQHBgnqfnvxPB/sk94Lau8qoRq2kGfKCVhJ0
/0R20bPPK5hFpxI9jTfPUjheEd1K/7xgA+OJzKDw7FXkRpzvutYBagGoA2Nc6gEY
C0K2pcB0+eQCbCQKlcPlgtFZvzr235b2c7j3Xs5cB4EGteQsuHZc3wvxvNPx3SsS
x7r7IMbD4XoXY7dFIE41/zItW7dwm+FqlRFoDc5F1n0tQhtecvmfw7R/85ycQR7a
/lRqDQ0VkhnZZz6dwAE5lR3fBQzfWIf7nYSn1s8dgjhsI33rUcLRK3XDgUpxDUXB
doM9r7SNK7RnZOjZzDcSk6AJa1H2NCEu6XzmbmKbXKo5T+qERFHHQROLAq1Z6vcC
+j4yAzGNbv+nO8Ij3w2hx9VYV4IY486h89QKBVoDBJunePcbhn6ONhY6YBuUmzfU
RazZl+Mnh5bkKwnXhJevzDrCLqpxpRGp/fvbzmlJM8tQLuIz+vQiPYHh4UuFgE35
3yvCLTU9a6nX6R8Fdxzd
=w11V
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--

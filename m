Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaJFTyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:54:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51803 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaJFTyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:54:36 -0400
Date: Mon, 6 Oct 2014 14:54:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Michael Welling <mwelling@ieee.org>, Felipe Balbi <balbi@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-iio@vger.kernel.org>,
        <pmeerw@pmeerw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] iio: light: add support for TI's opt3001 light
 sensor
Message-ID: <20141006195431.GD17445@saruman>
Reply-To: <balbi@ti.com>
References: <20140929140227.GD32403@saruman>
 <20140929183856.GA11871@sysresccd>
 <20140929185325.GA1939@saruman>
 <20140929223833.GA13111@sysresccd>
 <20140929224638.GA21681@saruman>
 <20140929234159.GB13111@sysresccd>
 <20140930212204.GC13806@saruman>
 <20141002180553.GI7933@saruman>
 <20141004031721.GA2846@deathray>
 <542FC15D.3070503@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <542FC15D.3070503@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 04, 2014 at 10:43:57AM +0100, Jonathan Cameron wrote:
> On 04/10/14 04:17, Michael Welling wrote:
> > On Thu, Oct 02, 2014 at 01:05:53PM -0500, Felipe Balbi wrote:
> >> Hi,
> >>
> >> On Tue, Sep 30, 2014 at 04:22:04PM -0500, Felipe Balbi wrote:
> >>> On Mon, Sep 29, 2014 at 06:41:59PM -0500, Michael Welling wrote:
> >>>> On Mon, Sep 29, 2014 at 05:46:38PM -0500, Felipe Balbi wrote:
> >>>>> Hi,
> >>>>>
> >>>>> On Mon, Sep 29, 2014 at 05:38:33PM -0500, Michael Welling wrote:
> >>>>>>>>> Alright, this is already ridiculous. Andrew, if I resend the pa=
tch can
> >>>>>>>>> you apply it since maintainer has been ignoring this thread any=
way ?
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> Do you reall think this is the best way to approach this?
> >>>>>>>
> >>>>>>> when maintainer doesn't respond for weeks, yeah! Sure it is.
> >>>>>>>
> >>>>>>>> Perhaps it would be better to explain what each field of the
> >>>>>>>> configuration register does and then we can move on.
> >>>>>>>
> >>>>>>> perhaps Jonathan could tell me exactly what he wants because I ca=
n't
> >>>>>>> handle back-and-forth anymore. Specially when he complains about =
stuff
> >>>>>>> he asked me to modify himself.
> >>>>>>>
> >>>>>>>> In particular the OPT3001_CONFIGURATION_L field needs to be expl=
ained
> >>>>>>>> such that the ABI can be properly applied.
> >>>>>>>>
> >>>>>>>> Looking at the docs for the Windows demo program the field is as=
sociated
> >>>>>>>> with a latch configuration. What does this bit field actually do?
> >>>>>>
> >>>>>> Still no technical information. Without all the facts how can you =
expect
> >>>>>> him to tell you what he wants?
> >>>>>
> >>>>> yeah, because clearly he doesn't know himself, right ?
> >>>>
> >>>> Could you explain how it works to me then?
> >>>
> >>> checking how much of the docs I can expose now, gimme a couple days.
> >>
> >> alright, here's a snippet of what's on preliminary docs:
> >>
> Firstly, thanks Felipe for going through the process to get permission
> to release the snippets.  I know this can be a real pain to do.

alright, np. Device will be launched soonish, so full datasheet should
be in TI's website in the coming weeks or so.

I'll wait until v3.18-rc1 is tagged before working on this again.

--=20
balbi

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUMvN3AAoJEIaOsuA1yqRE7aMP/0XtX3i9+S17a8igX3coArpz
dXi7VlWG2FPw5yfg83I5CO6DaIvvUjVvlN4h3wCHDTzAdTmHw4c01o4qQhQtW5cN
9m2RoU0/YTr+CSEqR+wmfqf7+NF94H2Qu6qGig4fxw2Le1/Yxn6DTm3x8GAK3hJF
S+nXCXbhRm/rz4S1GTQJOOR4tCvU64N23gTjUrsxsdbfA4ierhQ7Lsq06UbWWsog
bWJTbYo7BCVyBjSiWBCQg/pJmeRBUufvDvfqGqQKCBCNzcKNFV3WKqaNDxSQQA6V
P/YPi/bc9Sb8VZMhltF4xDsiBYGystCT3oS27e8J9FQWkNVVNJs6CprwvM7ukYjE
Hybx0rBg8WOhptpne7w38VhMIJoyH8Po+Vo13cG5ztQuEVC4UbjBMYtbya46e/Ep
kfvdLFx61gZMevLIEyebn6Ld0hbisNUIMcOAW1c6Exg3KWmQINH6WqSdnDMt+YLs
17MsD4OkJrj3Ch7F2d+M8hbfICK+FzcaTPkMLck2ahnl7THrdFJv6sz0gkwsB6CZ
UzS4gtMnC9OBZsxUU/Zxv5G11YF6vSBBucLzlLIR1VgHu3qKBiWgz351GKGQI3Ue
PycKsjgdQzOZkqMl5ZWAyYSOuG+ezsYTkJX29ihp0AtquV2esUt2gnHw/pubkddZ
FgQLEJ4fzt4oNWPmviYC
=ja9T
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--

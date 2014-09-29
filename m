Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaI2OS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:18:26 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38983 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaI2OSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:18:24 -0400
Date: Mon, 29 Sep 2014 16:18:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bart Tanghe <bart.tanghe@thomasmore.be>
Cc: Stephen Warren <swarren@wwwdotorg.org>, matt.porter@linaro.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v3] pwm: add BCM2835 PWM driver
Message-ID: <20140929141820.GA2273@ulmo>
References: <1398689686-30317-1-git-send-email-bart.tanghe@thomasmore.be>
 <20140825131908.GG4163@ulmo.nvidia.com>
 <5408395E.2030305@thomasmore.be>
 <54088008.9080200@wwwdotorg.org>
 <20140926071109.GA31106@ulmo>
 <54257C25.2000308@wwwdotorg.org>
 <20140929053311.GA12506@ulmo>
 <542960AE.1040200@thomasmore.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <542960AE.1040200@thomasmore.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 03:37:50PM +0200, Bart Tanghe wrote:
> On 2014-09-29 07:33, Thierry Reding wrote:
> > On Fri, Sep 26, 2014 at 08:45:57AM -0600, Stephen Warren wrote:
> >> On 09/26/2014 01:11 AM, Thierry Reding wrote:
> >>> On Thu, Sep 04, 2014 at 09:06:48AM -0600, Stephen Warren wrote:
> > [...]
> >>>> Oh dear. It sounds like we need at least some form of clock driver f=
or the
> >>>> platform then. I still don't think there's complete documentation fo=
r the
> >>>> HW, even though a lot of register docs were published which presumab=
ly cover
> >>>> the clock HW? Equally, given that the VC firmware assumes it owns mo=
st of
> >>>> the HW, it seems best to manipulate the clocks through the firmware
> >>>> interface rather than directly touching the HW. Unfortunately, I don=
't
> >>>> believe there's any ABI guarantee on the firmware interface. Perhaps=
 we can
> >>>> get one?
> >>>
> >>> Urgs... this VC firmware seems to be more of a headache that I thought
> >>> it was. How is this handled in other drivers? Surely PWM isn't the fi=
rst
> >>> one that needs clocks?
> >>
> >> For the other clocks, I've set up dummy fixed-rate clocks in the DT an=
d/or
> >> "clock driver" code to satisfy references by phandle or clock name
> >> respectively. Since the other drivers don't actually manipulate the cl=
ock
> >> rates etc., this is enough for the drivers.
> >=20
> > Given that this driver only queries the clock frequency adding a fixed-
> > rate clock to the device tree should work as well. Then the calls to
> > clk_prepare_enable() and clk_disable_unprepare() can still be added as
> > appropriate so that the driver doesn't need to change if a proper clock
> > driver ever gets added.
> >=20
> > Or am I missing anything? Perhaps the issue is that the default clock
> > rate for the PWM clock isn't usable? That would still not prevent the
> > driver from being merged.
> >=20
> > Thierry
> >=20
> The pwm clock is default unusable. To let the pwm clock run, It's necessa=
ry to change some=20
> clock registers. I've added the clk_prepare_enable and the clk_disable_un=
prepare functions. So the=20
> driver is able to work with a proper clock driver in the future.

Okay. Sounds good to me.

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKWosAAoJEN0jrNd/PrOh7ZQP/i6XmnKEeGrwV1mNbp9toamk
ffFxUOkmslZOj9XylTDiJk5TP22bd4s4DfW+my1uGV1L6vLyla8Ux+5EzhCle6Bo
7Y4MOZBEwtVbyMyWeRycTGBYwPjMaroPOVjk5BvoFjp1nJRtaUbwxP+1UpDP+7d2
Wvdf4Yq/QtcedDQj8ZDjBAZnxNLUPa4ttQ70neEZWJsa/UUJxQsh2yj+advgUqFU
w4yavsynGTz7z5rEqzHqi3d+6x2xRy555NBoah2iuTy+OG/nnD8/rqWOPSxjjNYr
R7Rh0KQ0brSgj2qtCBZ8jaCwNRNlBkL64cRPC6Fr36zOLYn0QE0dfEBJguRZsm42
2/WU5bJqSYNtrUGrb21+z629+UidvKpuRdrMc2mJW+yPwHpS9v83dgrjJFXvZSn/
huRmfuzt/SLRGao492JorGv/m3buMbaibMCbXt/pOIao8YZGAL5W46dcyJTH8pgb
dxWBUbRLadYkakrVNmP07Q+EwNP6RzTvJlAVZcip+28K1NvC/3Baq0bET6+BmnXt
BgM0t7SvU/BzZl3bBTROyKCKEH4HPXaJrbzKDcjaOPEQ3UgIZWQ1O7fUzbnGIl0g
+GHXPnqoeZyrkrHdaS1z7jiUtLCZZ/LpyxDejp9TyYZCElFJ74NFye22GrPLenF0
oi5wA54/SfAVWTX8Aguv
=IkHE
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--

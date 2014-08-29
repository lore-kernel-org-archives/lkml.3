Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaH2S5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:57:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40047 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaH2S47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:56:59 -0400
Date: Fri, 29 Aug 2014 19:56:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Message-ID: <20140829185610.GY29327@sirena.org.uk>
References: <CAD=FV=X1xOg=-_xZ70X5=ZzRLiuws_2gv5n2fj_AaLTYMq58=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iIOavGAISvUeFFLW"
Content-Disposition: inline
In-Reply-To: <CAD=FV=X1xOg=-_xZ70X5=ZzRLiuws_2gv5n2fj_AaLTYMq58=A@mail.gmail.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 5/5] regulator: RK808: remove redundant code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iIOavGAISvUeFFLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 29, 2014 at 06:13:10AM -0700, Doug Anderson wrote:
> On Wed, Aug 27, 2014 at 2:01 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Tue, Aug 26, 2014 at 10:18:57PM +0800, Chris Zhong wrote:
> >> remove the redundant code, since pdata has been removed from stuct rk808

> > I've applied this but if there's further changes needed please wait
> > until the MFD changes they depend on have been accepted before
> > resending.  This will be less work all round.

> Can you clarify?  As Chris makes the MFD changes that Lee and others
> have requested then the regulator driver needs to change as well.
> It's helpful for reviewers (and testers) of Chris's changes to see how
> the regulator driver changes as the MFD interface changes.  Should he
> just take you off the CC list until he's ready?

Yes, the frequent resends of MFD serieses are in general a problem and
since these ones still don't seem to be getting threaded they're
especially problematic.

--iIOavGAISvUeFFLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUAMzHAAoJELSic+t+oim9+vwQAJaWHeM8Pq0zaxEnY9xanWSr
HegWLq+DBWm9Sc+3w5HbMFPy9N4EuREx1Z1YhuhYmg4JU1sh2uIAinkwilS4BQKy
C5BmRgKTyR5AA3Ms7uJGkTT4OTpcXKOAqV6ZvQxJpGV4PI6N2uP53jgGTrHEzzru
I1VYjvabcjjQn7H8Jzdw/QLsmc02EkeqvgogF+SVNFkJ/zfvF/rJ4Xbx8Q2ksKha
7yj0464gEmV6ixb2lPO6yjj58B8Tt1dJFA4C/ktGbYESRATcX8M2u7ys9E7RRn1e
fEDsHPvalpZ/caCd7fFAzpLr4PQd9nnkj5WugYOwwvhUsYLWD+MOX/3Lg1U1J3IE
bXwJseSgkHYpHgEey36d5O0jJnyBGQQgngz2/NeVfX5KK5ogr0NJvltm7tp4ETC2
XMjj/KjTasNEQmqQl4xWTVJfACD01kUTLzZI17z4yNKDMya949S+wbEgap7DLazi
5eXD7obBYaZ1GXCCFMAPdDheAUdLisAI/Wxl1C/nULPcauude9rCAj62yFPEPT57
JW/Hsbf/WP4t2o8I5AoePV+bKiWbatngRZySKRC7Rd7bpAQLH257im3XK31+MTwd
jO4HjqKdCYdDwK0TxVYNH7EKkJ3NNrmqrwWOgSd1iWJnT40cegd3NXiEUrWyfAOd
GQz3dVQH0Fogl1gv2Gw9
=7zVz
-----END PGP SIGNATURE-----

--iIOavGAISvUeFFLW--

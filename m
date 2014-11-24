Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaKXPyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:54:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40523 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaKXPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:54:16 -0500
Date: Mon, 24 Nov 2014 09:54:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
CC: <balbi@ti.com>, Kiran Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH v1 2/3] usb: phy: Handle per-PHY event for connect and
 disconnect events
Message-ID: <20141124155422.GH20705@saruman>
Reply-To: <balbi@ti.com>
References: <cover.1416547297.git.kiran.kumar@linaro.org>
 <7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
 <20141121151105.GC7508@saruman>
 <CA+RfmHZo4FuH6-Z8+VFY7Ao5QVD-VmfdCm17ZrB6f7J8Xpo-Aw@mail.gmail.com>
 <20141124143819.GB20705@saruman>
 <CAO_48GFj2moODXtB1W9t6tbuvcyF2WgnakSDrbQRzPi+u=mc=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LwthZj+AV2mq5CX"
Content-Disposition: inline
In-Reply-To: <CAO_48GFj2moODXtB1W9t6tbuvcyF2WgnakSDrbQRzPi+u=mc=g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4LwthZj+AV2mq5CX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 09:19:09PM +0530, Sumit Semwal wrote:
> Hi Felipe,
>=20
> On 24 November 2014 at 20:08, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Fri, Nov 21, 2014 at 09:13:00PM +0530, Kiran Raparthy wrote:
> >> On 21 November 2014 20:41, Felipe Balbi <balbi@ti.com> wrote:
> >> > On Fri, Nov 21, 2014 at 11:31:21AM +0530, Kiran Raparthy wrote:
> >> >> usb: phy: Handle per-PHY event for connnect and disconnect events
> >> >>
> >> >> When usb is connected and enumerated in device mode or when usb is
> >> >> disconnected,call usb_phy_set_event from phy drivers to handle per-=
PHY event.
> >> >>
> >> >> Cc: Felipe Balbi <balbi@ti.com>
> >> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> >> Cc: linux-kernel@vger.kernel.org
> >> >> Cc: linux-usb@vger.kernel.org
> >> >> Cc: Android Kernel Team <kernel-team@android.com>
> >> >> Cc: John Stultz <john.stultz@linaro.org>
> >> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >> >> Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> >> >> Cc: Benoit Goby <benoit@android.com>
> >> >> [Original patch in Android from Todd]
> >> >> Cc: Todd Poynor <toddpoynor@google.com>
> >> >> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> >> >
> >> > this patch doesn't apply, please rebase entire series on my testing/=
next.
> >
> > your rebased version didn't apply either. Can you make sure you're
> > rebasing on top of my today's testing/next branch ?
> >
> I just verified that I am able to apply both this patch (and the next
> one - so 2/3 and 3/3) on your testing/next branch - just to make sure,
> this is the git/branch right?
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
> branch:testing/next

that's the correct branch, but here's what I get:

checking file drivers/usb/phy/phy-ab8500-usb.c
Hunk #1 FAILED at 447.
Hunk #2 succeeded at 459 (offset -2 lines).
Hunk #3 succeeded at 502 (offset -2 lines).
Hunk #4 succeeded at 527 (offset -2 lines).
Hunk #5 FAILED at 589.
Hunk #6 succeeded at 600 (offset -2 lines).
Hunk #7 succeeded at 629 (offset -2 lines).
Hunk #8 succeeded at 652 (offset -2 lines).
Hunk #9 FAILED at 701.
Hunk #10 succeeded at 712 (offset -2 lines).
Hunk #11 succeeded at 740 (offset -2 lines).
Hunk #12 FAILED at 786.
Hunk #13 succeeded at 801 (offset -2 lines).
Hunk #14 succeeded at 828 (offset -2 lines).
4 out of 14 hunks FAILED
checking file drivers/usb/phy/phy-gpio-vbus-usb.c
checking file drivers/usb/phy/phy-mv-usb.c
checking file drivers/usb/phy/phy-tahvo.c
Hunk #1 FAILED at 87.
Hunk #2 FAILED at 105.
2 out of 2 hunks FAILED

cheers

--=20
balbi

--4LwthZj+AV2mq5CX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc1SuAAoJEIaOsuA1yqRE9SIQAIPwmYs7v0Nuz5pbDS4aIAcf
Z/Jr9ggCTNS1urZobqNFDD4zz1jqQQjpV8IYuC3O75V+ZYHZ6wXa+Q+Uzw8cxQSJ
S7w0on1C+aTAT7Ud5PPBwdI81lM4al5UO+K6yoFn6tFH3KVvlj3TUtkhCALfD+QY
vIBGDKD23CVL+csTVC3wiSjo+Ofc/Iy0ju2k7TFYysmRIKhqP8SUCvaSok7DvQEk
gtQuW4OYnonCDiZJxHmxIjyQpTwx5N+oTwrdT9oBbD6vYXnsRRPfeTJRQOmEYl/7
YIvsgonn3kIR7QGIv5Ap+rP3BaKmTVvOfpTOCBz5bxE9wbtcAbBvBk7bvU2kHBX8
Yk9xMDQjgaraFtDwpPTgfCyg3IOk63DRhUmQZpZvosCGWdMggRIANt2cFGJhyq9D
cwa3wNSc+UN7PwASBtTmnbJovt/1jL5u5+UnYRw1Vd4WsPe06s4XSOZIoOREShSJ
bh+m1+hV0IbvOusX11LjxdP8ufy0mcOJM6hoKqkMXjuPC1Q+By2JNpYMat8gmQ+5
eR5b0bO9E8C7CnygZjXA3+x2+9SCjUsANY+mZ43kQyOfJWLwtto15ZyiCYqpyGAo
mEgpnYPFpA1vvN2gTkiyAL8Vuq4159qsnzA3P03HkipCkiNCt/Ua5cypFFwpg1JK
w8rCoofGuS2oAn31BMHV
=tG73
-----END PGP SIGNATURE-----

--4LwthZj+AV2mq5CX--

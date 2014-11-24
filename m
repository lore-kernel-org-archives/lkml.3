Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaKXQVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:21:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39560 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbaKXQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:21:34 -0500
Date: Mon, 24 Nov 2014 10:21:43 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
CC: balbi <balbi@ti.com>, Kiran Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH v1 2/3] usb: phy: Handle per-PHY event for connect and
 disconnect events
Message-ID: <20141124162143.GI20705@saruman>
Reply-To: <balbi@ti.com>
References: <cover.1416547297.git.kiran.kumar@linaro.org>
 <7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
 <20141121151105.GC7508@saruman>
 <CA+RfmHZo4FuH6-Z8+VFY7Ao5QVD-VmfdCm17ZrB6f7J8Xpo-Aw@mail.gmail.com>
 <20141124143819.GB20705@saruman>
 <CAO_48GFj2moODXtB1W9t6tbuvcyF2WgnakSDrbQRzPi+u=mc=g@mail.gmail.com>
 <20141124155422.GH20705@saruman>
 <CAO_48GFK_a=d+jUMR8-eqRVy1V_hSt8hKs2uOA00zzxstgV7pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBT+cnFS/G3NVgv4"
Content-Disposition: inline
In-Reply-To: <CAO_48GFK_a=d+jUMR8-eqRVy1V_hSt8hKs2uOA00zzxstgV7pA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SBT+cnFS/G3NVgv4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 24, 2014 at 09:45:35PM +0530, Sumit Semwal wrote:
> On 24 November 2014 at 21:24, Felipe Balbi <balbi@ti.com> wrote:
> > On Mon, Nov 24, 2014 at 09:19:09PM +0530, Sumit Semwal wrote:
> >> Hi Felipe,
> >>
> >> On 24 November 2014 at 20:08, Felipe Balbi <balbi@ti.com> wrote:
> >> > Hi,
> >> >
> >> > On Fri, Nov 21, 2014 at 09:13:00PM +0530, Kiran Raparthy wrote:
> >> >> On 21 November 2014 20:41, Felipe Balbi <balbi@ti.com> wrote:
> >> >> > On Fri, Nov 21, 2014 at 11:31:21AM +0530, Kiran Raparthy wrote:
> >> >> >> usb: phy: Handle per-PHY event for connnect and disconnect events
> >> >> >>
> >> >> >> When usb is connected and enumerated in device mode or when usb =
is
> >> >> >> disconnected,call usb_phy_set_event from phy drivers to handle p=
er-PHY event.
> >> >> >>
> >> >> >> Cc: Felipe Balbi <balbi@ti.com>
> >> >> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> >> >> Cc: linux-kernel@vger.kernel.org
> >> >> >> Cc: linux-usb@vger.kernel.org
> >> >> >> Cc: Android Kernel Team <kernel-team@android.com>
> >> >> >> Cc: John Stultz <john.stultz@linaro.org>
> >> >> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> >> >> >> Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> >> >> >> Cc: Benoit Goby <benoit@android.com>
> >> >> >> [Original patch in Android from Todd]
> >> >> >> Cc: Todd Poynor <toddpoynor@google.com>
> >> >> >> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> >> >> >
> >> >> > this patch doesn't apply, please rebase entire series on my testi=
ng/next.
> >> >
> >> > your rebased version didn't apply either. Can you make sure you're
> >> > rebasing on top of my today's testing/next branch ?
> >> >
> >> I just verified that I am able to apply both this patch (and the next
> >> one - so 2/3 and 3/3) on your testing/next branch - just to make sure,
> >> this is the git/branch right?
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
> >> branch:testing/next
> >
> > that's the correct branch, but here's what I get:
>=20
> That's very odd - I pulled your branch for the first time about 5
> minutes before I sent the mail? perhaps local branch updates?


$ git show
commit c9d655dccea0cb6df20ba5b39294a24be045ea4f
Author: Fabio Estevam <fabio.estevam@freescale.com>
Date:   Wed Nov 19 12:37:53 2014 -0200

    usb: dwc2: Fix build warning when CONFIG_PM_SLEEP=3Dn
   =20
    Building with bcm2835_defconfig, which has CONFIG_PM_SLEEP=3Dn causes t=
he
    following build warning:
   =20
    drivers/usb/dwc2/platform.c:227:12: warning: 'dwc2_suspend' defined but=
 not used [-Wunused-function]
    drivers/usb/dwc2/platform.c:237:12: warning: 'dwc2_resume' defined but =
not used [-Wunused-function]
   =20
    Annotate these functions with '__maybe_unused' to prevent the warnings.
   =20
    Reported-by: Olof's autobuilder <build@lixom.net>
    Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index ec5658a..6a795aa 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -226,7 +226,7 @@ static int dwc2_driver_probe(struct platform_device *de=
v)
 	return retval;
 }
=20
-static int dwc2_suspend(struct device *dev)
+static int __maybe_unused dwc2_suspend(struct device *dev)
 {
 	struct dwc2_hsotg *dwc2 =3D dev_get_drvdata(dev);
 	int ret =3D 0;
@@ -236,7 +236,7 @@ static int dwc2_suspend(struct device *dev)
 	return ret;
 }
=20
-static int dwc2_resume(struct device *dev)
+static int __maybe_unused dwc2_resume(struct device *dev)
 {
 	struct dwc2_hsotg *dwc2 =3D dev_get_drvdata(dev);
 	int ret =3D 0;

that's the head of my branch, which is testing/next. And I don't have
anything in my index:

$ git diff
$ echo $?
0


--=20
balbi

--SBT+cnFS/G3NVgv4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc1sXAAoJEIaOsuA1yqREayMP/iUruebvEPbCuCCHFkU0dCSD
jJyjbfFPUhlNXhipzbTUrHC/H1s/vaHewqbY36LfCg6FyVAXLTcLKac7mIpF4JL1
a5S5PZ2e3aGvkWy3oTCQhisVieIWEj5sK/vQuu4pWtd1cGi7CmeWOYUZ2JNxEoca
NCNFptT52GZHNqQCUyLVEGJZIq8BFoeVt3oZjHbtQyh0HAtgrZZwVYp2L9EksRuZ
GoPes2JtIrKRw3fbXz1J94c+PXSz0Q7pbp+/PND4IvMtZnoPHDbCU163OI7qhDkC
crWNcIEYkQk3R/fLCSYuG6dJptf530tEdBJ4uxS/LLvo6KO0UFT9Pv8J3Xr44Njj
TyHrBPp54qD7v880z1S7hZvi1AcOl+UnO13Q6gA6X44XVfWIcb2HYB3xHH+nqoRE
rLIV4TpMfXKlgPkDmFOVz9aPcAVXeMlmUhCqPa5YLk+mn2TgrabVmKR6IwUWOqoe
APhYBbNu0Z2dvtRp98ZDXF+VUH+VngR/IiSQ4nz59VnRaBu2Ipc9Ll+NVY/wV0go
vl3f+m8bJEBd+OAqHTG5s84aAuNzmq+m5jzxQi+ZJYt8eutqQeg7r9k+6zUarBaJ
AjIp6PUqJ0GCyYL0puCapUP7OZa1HU913H4X3Wn38zqB9F5zihHReOCMrdb121HG
dtBNNF+fHHljWbxgEY4V
=O5d9
-----END PGP SIGNATURE-----

--SBT+cnFS/G3NVgv4--

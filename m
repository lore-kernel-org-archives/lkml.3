Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaICOqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:46:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33781 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbaICOqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:46:43 -0400
Date: Wed, 3 Sep 2014 09:46:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>, Daniele Forsi <dforsi@gmail.com>,
        USB list <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kishon <kishon@ti.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 5/5] phy: exynos5-usbdrd: Adding Kconfig dependency for
 Exynos7
Message-ID: <20140903144611.GE31855@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
 <1409212920-28526-6-git-send-email-gautam.vivek@samsung.com>
 <CAN_we7MQAqEsRaQc_pkRE_KXx9zZNLDBR2aHUrazM30Nv3udmQ@mail.gmail.com>
 <CAFp+6iHsfg6Ru0LBN=JviV=-mSdmuSo9Te3EXYF+X8jssD_BYQ@mail.gmail.com>
 <20140902143711.GD16872@saruman.home>
 <CAFp+6iE4V4bWHGasr2qNC14mGNAfjQbgerCDMLLatnQQJ86NuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Content-Disposition: inline
In-Reply-To: <CAFp+6iE4V4bWHGasr2qNC14mGNAfjQbgerCDMLLatnQQJ86NuA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2014 at 09:32:14AM +0530, Vivek Gautam wrote:
> On Tue, Sep 2, 2014 at 8:07 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Mon, Sep 01, 2014 at 01:30:21PM +0530, Vivek Gautam wrote:
> >> On Thu, Aug 28, 2014 at 8:36 PM, Daniele Forsi <dforsi@gmail.com> wrot=
e:
> >> > 2014-08-28 10:02 GMT+02:00 Vivek Gautam:
> >> >
> >> >> This USB 3.0 PHY controller is also present on Exynos7
> >> >> platform, so adding the dependency on ARCH_EXYNOS7 for this driver.
> >> >
> >> >> +++ b/drivers/phy/Kconfig
> >> >> @@ -186,7 +186,7 @@ config PHY_EXYNOS5250_USB2
> >> >>
> >> >>  config PHY_EXYNOS5_USBDRD
> >> >>         tristate "Exynos5 SoC series USB DRD PHY driver"
> >> >> -       depends on ARCH_EXYNOS5 && OF
> >> >> +       depends on (ARCH_EXYNOS5 || ARCH_EXYNOS7) && OF
> >> >
> >> > shouldn't that prompt and its help text be updated to mention also E=
xynos7?
> >>
> >> Right, even that has to be updated accordingly. Will update the same i=
n next
> >> version of the patch. Thanks for pointing this.
> >
> > I would rather change that to ARCH_EXYNOS, unless Kishon doesn't like
> > that idea. The thing is that this will likely need to be patches for
> > exynos8, 9, 10, 11...
>=20
> Yes, after we have the 2nd version of Exynos7 support patches, it makes
> more sense to keep dependency on ARCH_EXYNOS.

thank you, that'll help new silicon wakeup; one less thing to patch :-p

--=20
balbi

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBymzAAoJEIaOsuA1yqREYaEQAJ9dKi8ErbHY2N98fpeo3a3W
pqe496n8nmczlK3x1mCcEYwqPQcX95mDI11iKArSfCnaSQA5shMoGel3tjWFS6yQ
3nCVpoi78PLvgwCu6HDPOuCCa74HRnW1eRS+gnnnEoVA2oufxU76G/f8WkYJFQkm
EyMUZ+4nn1XrdXyudpaf8hWzVu7Ru2TvUx4HTe0QLRmFr1uxpfN/sAKAcjmx+Kn1
zITKZ22qYt1RlN+mB3YqpENZzF9LV57AWHvy+RtJarFbMtHBJsbYruXKoxLbHbHK
Q9qtDHNNq27cNAWlLsjFVAXMgAfUNkVfX/9qsH0NCidGVf4yD/SlM8QALaH5fKHX
/JjBvjWU9qTScXCa3IcQxv8uOcgQdAioePEHQ7cvU2aVZzvRC3rbbXgsW46AtJqO
0niicdNmkhv2E0ImlSWgc3ZvG9z440AaeMKJuqH22utUNUR6I0hngf1jlyJUa59P
m5yrWXkYJVnSwKkW9I/KhDPGWYbygAcMVsS9ReN0p5I+fXAiqi0BfQlcNgrCyJfs
QPQ6snXCFdQJMkz5xDC0rumxgdLELMNuMd83HeHuOfRZaurHkXswS76rsI8yVRQ5
+eIuSDB2/XGrrWlTo5YThB32dd+Ak54g0rtpl1Yqg13gSbmnmQif7fByGJ7RxHIp
eqrAfEoXvlxElVLR6bSu
=ASkT
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--

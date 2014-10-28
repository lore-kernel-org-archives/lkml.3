Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaJ1OnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:43:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56607 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJ1OnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:43:12 -0400
Date: Tue, 28 Oct 2014 09:42:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, David Cohen <david.a.cohen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141028144249.GD8123@saruman>
Reply-To: <balbi@ti.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013191405.GB29810@saruman>
 <20141013192404.GB4034@psi-dev26.jf.intel.com>
 <20141013192632.GC29810@saruman>
 <20141013193618.GD29810@saruman>
 <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 11:15:20AM +0100, Linus Walleij wrote:
> On Mon, Oct 13, 2014 at 9:36 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Mon, Oct 13, 2014 at 02:26:32PM -0500, Felipe Balbi wrote:
>=20
> > I also noticed that this is missing:
> >
> > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinct=
rl-baytrail.c
> > index e12e5b0..7db5ab9 100644
> > --- a/drivers/pinctrl/pinctrl-baytrail.c
> > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> > @@ -614,3 +614,9 @@ static int __init byt_gpio_init(void)
> >  }
> >
> >  subsys_initcall(byt_gpio_init);
> > +
> > +static void __exit byt_gpio_exit(void)
> > +{
> > +       platform_driver_unregister(&byt_gpio_driver);
> > +}
> > +module_exit(byt_gpio_exit);
>=20
> But the Baytrail driver is not a loadable module, it is bool:
>=20
> config PINCTRL_BAYTRAIL
>         bool "Intel Baytrail GPIO pin control"
>         depends on GPIOLIB && ACPI && X86
>=20
> (...)
>=20
> So I guess it won't need handling for removal, as it can only
> be compiled-in.

you can still unbind it through sysfs, right ? The thing also already
provides a ->remove() method anyway.

--=20
balbi

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT6tpAAoJEIaOsuA1yqREyd4P/1u2RmMoV9t9VrgfXSt3IAOK
KCtgG/oAH+VSmOeLj480lTWupWNxOqV8MPaDcVec7xCcNr8pVGtTqWIJ2a1fNjLC
99dxr9PCeB93g71p7HbAFRI2rHFdPjpKBP9sikFUAI8EpryevSzPUQrKN0T829Dv
OGZUTEOjd5GXgOa008RQ0r7LCebVOitwfG1chasOwVXHs+qzhfL/Y3mS+ftnwpRS
jMGCKJkyE6vIST/f28gtC8j77Wu33HFw4s3elha2nETHDBTnRerljKLi0nZ74FUP
sw5PnMWlwkagDHSCeJS5aNN1w+GIoSZKbplBraMxf3qOIgjKFIsLSV9PGdz38RZm
kJGxPQ0vrFbaCg/6226DFynb4cXVfaC6xYKQqF5O/oP08iMiOplRMrtwE5FI0xAX
SSUNUNTg5MPnkbXHeNp9pod81U8TTuMgB/QKQsNwER2UdO/c+ZwR7yqbUknSE0C8
qSlHTid7rb7MfpsveQrrHByWjxEagq3mldUHm8p8O2nkYMugG4M+UyHA8QHIqVr2
I+LqXpxdaZ6qSwQMOOmDt5cY7ucjESJWmEUuGZugKetoZctfajDDGjAMUVo+wAVi
v00t6X/awCuh2lwuXGKSbn6JSUS+gLC7SN/rotFkXHNZ0WK/uio/hU/k8AvS1ctU
1v1aufg4OFgcQbsxZNnQ
=so8J
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--

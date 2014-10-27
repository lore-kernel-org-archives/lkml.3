Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaJ0ReJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:34:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54899 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJ0ReH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:34:07 -0400
Date: Mon, 27 Oct 2014 12:33:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v3 00/47] kernel: Add support for power-off handler call
 chain
Message-ID: <20141027173310.GB16005@saruman>
Reply-To: <balbi@ti.com>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <20141027160324.GD10814@saruman>
 <20141027171617.GA19379@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20141027171617.GA19379@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 10:16:17AM -0700, Guenter Roeck wrote:
> On Mon, Oct 27, 2014 at 11:03:24AM -0500, Felipe Balbi wrote:
> > Adding Johan, who's working on RTC power off for AM335x devices
> >=20
> Hi Felipe,
>=20
> is that the rtc-omap driver ?

yes it is.

> I am tracking linux-next for related changes. As new power-off handlers a=
re
> introduced, I prepare patches for those as well. I currently have patches=
 for
> the following two drivers in the queue:
> 	drivers/regulator/act8865-regulator.c
> 	drivers/rtc/rtc-omap.c
>=20
> I plan to send review requests for those patches in a week or so (I think
> there is still some change pending to the power-off function in the rtc-o=
map
> driver, and I want to wait for it).

yeah, Johan's working on that.

> My current plan is to send a pull request for the series directly to Linus
> when the next commit window opens; this is what a number of maintainers
> suggested I should do. This pull request would exclude the last patch,
> so pm_power_off would still be there. Next steps would then be to submit
> another set of patches to update the newly introduced power-off handlers
> and then to finally remove pm_power_off; this would probably happen after
> the commit window closes.
>=20
> At least that is the plan unless someone has a better idea ....

sounds like a good idea to me :-)

> There may be some variants; for example, it might make sense to create an
> immutable branch with the key patches (1-3 and 8) to enable others to use
> the new functions immediately. That would require Acks from affected
> maintainers for patch 1, though, so I can not do that yet.

alright, I think an immutable branch people can merge would be
appreciated nevertheless, but I'd certainly defer that to arch and soc
maintainers.

cheers

--=20
balbi

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUToHWAAoJEIaOsuA1yqREuxAP/0qWwU4sAxICAhF1ymX8ip2N
Z/loXagIwC9RqzS7oKAGZIeBYT5nUOsNjbcA45D3GD9/gmIjdirixP7OvkhjFG6H
jC0Vr1uiE9dRwEJvTzpASuCZcxKS9kNO/DDWZJk+Ktjr4izCXZ68hQARCv6epbX0
KEPBbQAvmYIuC4Yc5caHmh7/TWsOnp5Py/Hg6UGY1szmtWXU9PKFwoDZB0b7WCdv
uKIGLPPr7ilFR7+lDeIC65ziNtT26r00LTA81l58iQqIvJD1mfYt95P+IR6C1h/A
LZLx2ZkULY8tAT7XzYLhOs1BeydCWDpe2I44UrxkKlhholigCFKuG9lRkDAJ57mD
u3rQKBS98FvJUeraNWj4YRR/Ugy/dU4+vY2BNqnj7yX8z6jvqcEWxosn75JDDCrG
iTaU47Y57F80NELox9yjmY0GzZGody3rlliOIFrtyR3/aZmT/BguqRuqTeJC3j/H
bXpl1rskY5O8QTvxisS6MXOJI4BCi2olnjzU+LOUIvZ4+719SzyNmmr8NC7uzWya
dkw1W8UzJIV52wdlz5d0dNm5uFePncIpZfUI95aqcxmDfgc9G0X9UUgwlM/kvI2H
o/1DlJ9FmTKyxUUPWbkxH1sGZ/J8Irm2HSYmx+iZsnj+fSOa59ZkcVmbnGUs4LZn
o0LF8kq7aTK9pTXj8S12
=1DHn
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--

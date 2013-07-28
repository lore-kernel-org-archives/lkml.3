Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3G1Mz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 08:55:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45559 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3G1Mz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 08:55:56 -0400
Date: Sun, 28 Jul 2013 13:55:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20130728125534.GX9858@sirena.org.uk>
References: <1374773943-7454-1-git-send-email-p.zabel@pengutronix.de>
 <1374773943-7454-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSx1R+zV/vyrECJk"
Content-Disposition: inline
In-Reply-To: <1374773943-7454-2-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] mfd: Add Dialog DA9063 core driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xSx1R+zV/vyrECJk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2013 at 07:39:02PM +0200, Philipp Zabel wrote:
> From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
>=20
> This is MFD module providing access to registers and interrupts of DA906x
> series PMIC. It is used by other functional modules, registered as MFD ce=
lls.
> Driver uses regmap with paging to access extended register list. Register=
 map
> is divided into two pages, where the second page is used during initialis=
ation.

Reviewed-by: Mark Brown <broonie@linaro.org>

This depends on

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/reg=
map-irq-ack-mask

Feel free to pull that tag when applying, or I can apply this on that
branch if that's easier.

--xSx1R+zV/vyrECJk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9RTCAAoJELSic+t+oim91gcP/iwJboPPDfObFTOT1aNtJe+i
WxQscYB73i+wFvqDwQ/pHclHNBrAH6DK3uLRpYR6O2M2TFxB/+tTjsJodqU94kaC
Lz0Xq9rrMxs9WlvYOvPJpQ4MvgnoHhtsIrqRTqrl1+1lP76KWe62gNom+14pxOd4
t9Qm8X5cgLxqzwAFN6Ue5gQGjZwM55XF9yxfn/emz51zvmCB8y1Gzn6e5Xp1SpC9
wGs946lt4YTm4u5/kBWuTpzzbC/kZEGdCIKMPTS7WFmiB/rh6VJr66fHxd2U6uDG
ERtk4ezfTZ0HKzHWv7NokqEmKbJlC6mBENX7H+Qn/N1F/RfXdXGGzx3YAa43Jd7O
wD4dtz3BK54bm5psiQFRKqcQBDaZhFLr38bpOqboGPDzP6AUA7wUkY1NEzCsZ0aM
S1GcezpD+vMV8kl62u8pDWvsohPxlv+oNgxwalZWhVTamF0Cgpv1PpJ+8mRT5o6p
GiptMrHn6dPDNZiKRhGRfN0D02bRl+xFyb6s1f9hflRqpZAk6A/E2NFjB8cpgqm3
tRBn1LP0PQe2aKWI073EwkM4HMj1vEw+RtuDyJad35HxWlSQREaKFpJgdsS5crIf
CFWKjMNBGef6rPvc2le5nwiOM9Lv5SvhOE1hi2+QhUpN9lUw3pQ3Ap4p6LgWgaQV
5LD7eVi6lubc+w/yrrdv
=TzQu
-----END PGP SIGNATURE-----

--xSx1R+zV/vyrECJk--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaHASne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:43:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40595 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHASnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:43:32 -0400
Date: Fri, 1 Aug 2014 19:43:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ks.giri@samsung.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, mollie.wu@linaro.org, t.takinishi@jp.fujitsu.com,
        khilman@linaro.org, lee.jones@linaro.org, andy.green@linaro.org
Message-ID: <20140801184314.GM30458@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
 <1406896365-4971-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="11IAkegDWp8TRrA/"
Content-Disposition: inline
In-Reply-To: <1406896365-4971-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.197.121.167
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv10 4/4] dt: mailbox: add generic bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--11IAkegDWp8TRrA/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 01, 2014 at 06:02:45PM +0530, Jassi Brar wrote:

> +Optional property:
> +- mbox-names: List of identifier strings for each mailbox channel
> +		required by the client. The use of this property
> +		is discouraged in favor of using index in list of
> +		'mboxes' while requesting a mailbox.

Can I suggest that if we do want to avoid strings for some reason (it's
not obvious to me why) then we include a recommendation to provide
defines in a header file in order to improve legibility.  That's pretty
minor, though.

Reviewed-by: Mark Brown <broonie@linaro.org>

--11IAkegDWp8TRrA/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT29+/AAoJELSic+t+oim9Z0gQAJRm9uoGH3PxJ/IPZhHouqJQ
sC6tl9efWmMQg2WLo/ZYGJoiRjwV2tfvpznyex11zYHMtVJU1rj5nKxd0IGVA+ux
qA5gH2h+hJF8SkoYqcu4IuTyCvv0arBx3fly+0XyH0kH306gI38JapCX7eGrK+Mo
fjdub/UXSc79anNC34qLcB8V/s6VoIJYiM/IPoLgShdjyM+ZRQBvhNZ65RUmPv+l
uqiFvgIHztXFjGTfXbqvoZ0ZPgWBoDEIELrmeXIzynCTBuUxFHUOeQwBCvdHlztd
fj1VT5qTu6l13Sv2lDEU7oWVjrPUF1Kk44Kxk/NJHoW+NSSD6AJexdxj3ae8SHLK
9DoiAbPxB948ylihypZcMEDWElvVMGr/rJKK1losETK4GOywOGo4TsWZEGt49zkv
NYY8B6SMbWAKSL2MN+bdh9ZFhQUyRb+NWZVLDQSMVGmBm9Vo4tXx2eEro461JgB/
YeNH45+s2Z46s23/ffwKGb9/2as6ZaXyBbyJbHqkK6gv6Np3N2+u5GFTmq39HRqK
JA3Dsd8/wjLSYBkVhfawAZWIzwNxhLXyO0CRgG0AOuhhdImZnN3q4UIweWMnILWE
DuF50NOEgFK9/NLR0xHHQAUTLfzAmbsVYJzeNdQmrqjyhXIMV8mPHyC725f+/tin
nUvhiv/NIDoWCAYdONkq
=00ie
-----END PGP SIGNATURE-----

--11IAkegDWp8TRrA/--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3GYUEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:04:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54151 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3GYUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:04:07 -0400
Date: Thu, 25 Jul 2013 21:03:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olofj@chromium.org>, devicetree@vger.kernel.org
Message-ID: <20130725200343.GV9858@sirena.org.uk>
References: <1374781320-10793-1-git-send-email-vpalatin@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qsJIsz+CuDui6lgL"
Content-Disposition: inline
In-Reply-To: <1374781320-10793-1-git-send-email-vpalatin@chromium.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: read low power states configuration from
 device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qsJIsz+CuDui6lgL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 12:42:00PM -0700, Vincent Palatin wrote:

> +- regulator-suspend-disk-microvolt: voltage applied when entering S2D
> +- regulator-suspend-disk-disabled: turn off when entering S2D
> +- regulator-suspend-mem-microvolt: voltage applied when entering S2M
> +- regulator-suspend-mem-disabled: turn off when entering S2M
> +- regulator-suspend-standby-microvolt: voltage applied when entering standby
> +- regulator-suspend-standby-disabled: turn off when entering standby

The reason this isn't in device tree at the minute is that suspend to
disk and suspend to RAM are somewhat Linux specific concepts and the
whole thing gets more and more dynamic as time moves forwards with the
suspend state for practical systems depending on the instantaneous
device state prior to entering suspend and the bits that are fixed often
involving sequencing elements and so on which get fixed in hardware
and/or bootloader.  Do you have practical systems where this is needed?

It's also not clear to me hat the -disabled properties make sense; if we
have properties for the state when enabled I'd expect them to allow
things to be marked as enabled or disabled (with don't touch as the
default).

--qsJIsz+CuDui6lgL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8YScAAoJELSic+t+oim9NfUP/j6towBBTl5vzixL1c1Cyor6
xySPfFEuy8VYWYTu00k7vPsQj4VFQccixmEeEWgpG9Uk/DjSAT3bLnHTziyXbBz3
QJkcFAjLHYXZvsAJOwiTX2OQKY0T63GkdyK8AfJVG4cKx/G+TSt/GLiBe2KbHlZp
8wJp/DsJ7Mc9R7Ka/SzuWinDssgu9T/X3SNLdZx9/xm/wK71V5Wd9cAyoOH0H+Tu
XmQqKG7xs/pz9+WgkVxoSn86XHhk65qp39sqyparoBnicxqOEwO6CksdYKlK5YZm
WIRV4F75WBY0PiDqPx04ktx6ZDGLQsicLoXXETlaI6e7Eik2mfHckSnOmuD5dLKH
gVF/pn0soDOshCMypq8vbfixYMB8V58YDeV2rSDVor2cxabEoPJek5aufZR74Y45
Y/mQt13xaf2shdhsEXOuLGEaL76qDW2kSfULWXtOe6TGyzUxTGA02idpjZu59Bz6
Up0jh50dsiL6Gq0GLwZOb65xW9seFJ9KlmiNo7paeBIjMIdyJSrLg1kUxHiwVuZd
RrzfZCl2XTvmHhKqtSzwT+tIngWsuXnZDKTY4hZYwpGLUt/2gORIUGx+DOReYgA4
OizTn5TRhlX8gwBx6reuh2mJGbb126Rl+VzWB/NS3hsRZp11I7nouWeiIvhgVnWP
Huh14gnaJqISPJT3N1C/
=0Xjs
-----END PGP SIGNATURE-----

--qsJIsz+CuDui6lgL--

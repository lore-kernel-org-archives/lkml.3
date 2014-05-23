Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaEWLlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:41:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40081 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaEWLle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:41:34 -0400
Date: Fri, 23 May 2014 12:41:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Linux-ALSA <alsa-devel@alsa-project.org>,
        lkml <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Doug Anderson <dianders@chromium.org>,
        "jerry.wong" <jerry.wong@maximintegrated.com>
Message-ID: <20140523114113.GE12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
 <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
 <20140522103039.GD12304@sirena.org.uk>
 <CAHbNUh2QHv8n7Y19qfO7BagX5AWe0i17MjDvr7yOpHf6YNGW4A@mail.gmail.com>
 <20140523111446.GA12304@sirena.org.uk>
 <CAHbNUh152xgyVxcCHiv0M6PLw8DE7KZ990WG7uRWWFBc8sPWRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fjxFa3KHLyh6LS4q"
Content-Disposition: inline
In-Reply-To: <CAHbNUh152xgyVxcCHiv0M6PLw8DE7KZ990WG7uRWWFBc8sPWRQ@mail.gmail.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fjxFa3KHLyh6LS4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 05:06:27PM +0530, Tushar Behera wrote:
> On 23 May 2014 16:44, Mark Brown <broonie@kernel.org> wrote:

> > Should be clk_prepare_enable() and similarly for the disable and you
> > should check the error codes but yes, that looks good.

> I was planning to keep clk_prepare/clk_unprepare in probe/remove.

Why - what purpose would it serve to leave the clock prepared but not
enabled?

--fjxFa3KHLyh6LS4q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfzPWAAoJELSic+t+oim9iEAP/in4oIa0UZDAiTrzCqEakgNX
9r57NnpWbaLq4c7zYrursK2kl6SNDdgNQOHP8vebvqQsFcYe/Wvi4PfYA8tZlNZf
ISMmvvVBJcR/NkJrOy/zEK+VtsO1T14UoV2G9vPuzMYpyviSOFfUvDta2BaJR6Ig
TXvhJVtD56wNdLr8knMx1xIiQn2tEpO6N73RVWE30eIsrvTEmFxEDeWNkrbYcc36
pN2tmmOdbRBI8JSLlYTroZ6KekN4iySeZLlq4mbmdQblZzpW4mtL3y8+7Xl0EOMA
Ij2Ynh2FnXQijyGj35nnwp3lGKV3gfZyYvni48TGwRe//JP8Lj7+HUZtx9eh+mDI
vaeAhPJnCgBcHF4Rb4cjsQKjcVnt3PgWzAHsN/7BK3I65xRQZ9/cwPNLVUw53puq
o9vcR7UOwMW6UK6tpXa510RC5lVyLQ/OspXXw2XsY2rtfxwOwhaJWP0bi9O7GARb
Flwk/4/dnwoFhth2jGts/6YM4cymfN7cwPoKHO/YHknIBMt61WqaoQ3GACHzqwFf
9d+j/hIOhIDwQQKli9bbgqAUQk0qNPMnF+J1S1kBXtcby9OuJYfXf0lbTwoorESa
4t1P4oT9vquBtlqh3FW729vRdj6W7fGRnkIlyE/mTEe7mdf2P2L9DCIfr02i6d/c
h0qkN7Ba45ZXUdVFJd1X
=PcVO
-----END PGP SIGNATURE-----

--fjxFa3KHLyh6LS4q--

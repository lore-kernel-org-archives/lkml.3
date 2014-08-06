Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaHFUM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:12:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50269 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaHFUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:12:56 -0400
Date: Wed, 6 Aug 2014 21:12:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Varka Bhadram <varkabhadram@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, Li.Xiubo@freescale.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        b42378@freescale.com, b02247@freescale.com
Message-ID: <20140806201236.GO17528@sirena.org.uk>
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
 <53E0B926.9010103@gmail.com>
 <20140805110735.GA16503@MrMyself>
 <53E0BC95.7040208@gmail.com>
 <20140806024236.GA17879@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZWXtK32sF+lMTTLi"
Content-Disposition: inline
In-Reply-To: <20140806024236.GA17879@MrMyself>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZWXtK32sF+lMTTLi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 10:42:37AM +0800, Nicolin Chen wrote:
> On Tue, Aug 05, 2014 at 04:44:29PM +0530, Varka Bhadram wrote:

> > Reading comfortably is important for us...  :-)
> > see this:http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt#L46

> I know how to write a binding doc with indentations to make it clear.

> What I'm talking about is that the doc was created without indentations,
> so I don't feel comfortable to add indentations starting from this patch
> while leaving the old lines in totally a different style because It's not
> helpful to make people read comfortably at all but only forcing people to
> think why these two lines are so special to take some steps back here.

> So personally I agree with your idea to make doc more readable. But what
> I prefer to do is not having a conversation on the style within this patch
> but to create an extra style-refinement patch later after this one.

This is the right approach.

--ZWXtK32sF+lMTTLi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4owxAAoJELSic+t+oim9KcIQAICotBQolgWw5UxLxsPdDXn6
0FWS1aFBrD5ihL5ddLrznh/gHaCclN1FQWggU/LjmDjfXr4tddRSUP0NYgTo8HBJ
fCKLmrXe/sfbMxl7W8sz7DuXLvy8qO7Q5KYjX4B8HKAu23m/trwcux25vkOpi5dP
T7sHjU0pyw6zm+62Knv/IvUiPMePRjS4OkAPo5F+vYWG5rtHsGnjPdcIV+SnBxPj
n17q7guf54qL4Or8bbT0G5Tmhiuz1m6ji/dObt8e7OSvd/83O4oreMg5uJ0umLWT
Ylrg7InGH2m8rCF6EQs9GoEQVttfI00uE5TQPxweO+WssyhrAigTunslnuUBVzhE
EJzNzABbawTE8oxlynWyFMJJWSoNSBHwUgXSqdPqq5FdB5ueZu6FIELQU/8AD4He
mAWAlehGQj8Sm1ppHKjw8eRWh2il8CDjk8vrFzxTAvkPrht+f2LwkbGMPGEA7TIU
t85u2rxwGQ6UdZNriA+JawhCnKDVBWXQvTkPosrsjW+Z/FIYbYy7fugfyF7P6H2x
w1kqX3LqPywO+A4KaHMQyMYJ/pgDsHuxj6irMGzSC5jVe4CPOqGGUp4y+i8QNGYc
/JwWxZdWITPD12gJRF+r1ZceNcu/BYEcviUHx7EPzz5iPm6iYtFchA1On4Ih88yL
gudDN8hYeYPjVgDCWaQG
=FNp5
-----END PGP SIGNATURE-----

--ZWXtK32sF+lMTTLi--

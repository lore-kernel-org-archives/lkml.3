Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaGVALZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:11:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48585 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaGVALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:11:24 -0400
Date: Tue, 22 Jul 2014 01:10:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140722001053.GO17528@sirena.org.uk>
References: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk>
 <53CD0B17.5040706@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vt4ed5MNefdcgji4"
Content-Disposition: inline
In-Reply-To: <53CD0B17.5040706@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 00/13] Add Maxim 77802 PMIC support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vt4ed5MNefdcgji4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 21, 2014 at 02:44:07PM +0200, Javier Martinez Canillas wrote:
> On 07/14/2014 01:35 PM, Javier Martinez Canillas wrote:

> Mark, Mike and Alessandro,

> This is a gentle reminder to look at the patches that touches your subsystems
> and provide acks if possible so Lee can merge the remainder set through the mfd
> tree.

Please stop nagging, you are chasing after only one week which is
excessive for something that isn't an urgent bugfix (especially
with a series like this that has had many rapid repins).  Several weeks
to a month would be more appropriate, and then resending the patches
rather than sending contentless pings is more useful.  Sending mails
like this just means that people have more mail to read that isn't your
patch, it is more likely to get you negative attention than positive -
for example, I will tend to deprioritise things where I'm being chased
too urgently as I do not wish to encourage such behaviour by being seen
to reward it.

In general I would recommend taking a step back, slowing down, and if
you are not getting a response either thinking of something else to do
in parallel or trying to do things that make it easier to accept your
change if there are any (sometimes it's just a case of waiting).  Look
at how frequently the relevant maintainers tend to respond, at what the
previous review comments have been and also consider the possibility
that people might take holidays or just be busy.

--vt4ed5MNefdcgji4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzawKAAoJELSic+t+oim9G4QQAIEBPBa74YKG1g3X0myqrKQu
y/Y1m4hQ5O4r2iRxtbr9VdRdOKe8K52beu9t8KROR1P4hVDTLfOduvhR/nd8a7iT
b9L3bqmGVNDiJnijGp5CMtM90zpaWSSK+9/JAbyIPVh2JKlgkGHXCzA/I0Sgtmo9
ENf5JtbR/pvBIKqFfd1ObouZPQ3fo1rbR3KZD24D4VZdfzGwnm/riSBEasYCM3CW
b808Kr+9cpiD8j0TnHn4zxTdAaDLYfUmTalmHfJAKNzS0TmmBMMquiSxUBd+ln4Q
F0fK+UYnja1DcW/gQCIBw8tXTHCl2duxT/LBl8QWIkH0qpolR8tiHB5f7Ontc7b7
hBuTiB1Ut5EEC6BTInzZy77JXb7Ip9MI8EHfq/eqn1y0UyAC0/1cxAC8VBEVcdja
Ry38e5piTjaZutl+1lvvM8+gxasfMCGpjsN+3KEQnHyjDDubRMsfWLrl89SMqBps
kX/21gdhJ9FJ2jmqheoNLQeE/IpO41dpH6xG+HRBPBCoPxOg6PCNfrCCr2JeZZX+
cWBmO+iPmlSK0eemfdNcQKm7mVEOBTkL/JbPY3oTYoFzHxoGshWr5sh88GhRmGvw
F0Z86mJIuB8Vfv6QGX9Yt87VDYrDXbj2m8QIoZRgPqN1mf67AD+WjSYoevuULQCG
5xYUg6PmrlMU21jsfko/
=ReWP
-----END PGP SIGNATURE-----

--vt4ed5MNefdcgji4--

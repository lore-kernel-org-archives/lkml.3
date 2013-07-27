Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab3G0Kk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:40:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46611 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3G0Kkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:40:55 -0400
Date: Sat, 27 Jul 2013 11:40:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Message-ID: <20130727104018.GC9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
 <20130727084825.GA4707@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBlFrcG9zwrDu6zE"
Content-Disposition: inline
In-Reply-To: <20130727084825.GA4707@netboy>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBlFrcG9zwrDu6zE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 27, 2013 at 10:48:26AM +0200, Richard Cochran wrote:

> [ I disagree about the "more thought" part. The current discussion,
>   coming years too late after the introduction of DT to ARM Linux, is
>   contrary evidence enough. ]

We did have exactly the same discussion when the DT transition was
started - this isn't something that people only just realised might be
an issue.  There was a deliberate decision to focus on getting the
technology deployed to the point where it could be used as a straight
replacement for board files and accept that sometimes the results won't
be perfect and that we may need to rework as a result.

To be clear the idea has always been to try for bindings that can be
stable but we didn't have the process to guarantee that and there were
substantial barriers in place to creating it while there was no critical
mass behind adoption.  What people are saying now is that we're now at a
point where it looks like those barriers can be overcome.

--UBlFrcG9zwrDu6zE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR86OPAAoJELSic+t+oim9XroP/3jojhlzh7bG35HUUh+UW2ST
juZmTJvG8xt5x2Tg87ZW8OgMLP1pcA2ctl3qtnO/F9QaoFClB3r+iDPk2G3kbAHd
fTyHi2+BGMD26vfXQlmbWD7mBgubVFR2uxLHQPmmK19xkiNvCkD+S7ddXJGYWtL9
fX+G828+c2F6hPqWgJ4ZBh/srCvucbR3oxbFRCMT/9/pqzgg3q0HZgiBxiXXo14+
/4JnODq7gzh/vMA/rP9wqpinZ01m0GTzEhFiUeUl4sDAH/PNFNqqtx4hC0HoIbnP
O0MwUB1mljgOKE0cDVU/MYgPpwXqL6hHKrKX4ZWIkycZolh2HPYD+ULlLqNM7zk/
YEKM4Ke6GVrvi2Ub8OHoFT+b2IRlTshpL3XVNm5zJe8oEffm/vd4e0Ps7swwI1y2
vgciKNZUV4LpLCYYVVlhHBQCccpfsjSYxcqjHHoe9K/uJXXSHFj2ZW1FqrhQUcP1
dLWrpstbasDdopg+Ovq+JgQf6i+o6MTg7GPaOctd1wpD4T9h4ROBNR5ouPOzKyoe
xGXbH8iWkE5ql8+wcedjqBp5YHjprOXYprTbRzyO+B4KXXAgg5zezSkGi0Z7+IUr
aoH6uZgikaQQE/8eQipMysjaHxIQhflqX3BvDiHhiWNLzXzvss9zrRpSulmC6r8Z
XHhQijo7HGL8/wsP6pvY
=3I9O
-----END PGP SIGNATURE-----

--UBlFrcG9zwrDu6zE--

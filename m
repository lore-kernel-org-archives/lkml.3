Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3G1RmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 13:42:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46389 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3G1RmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 13:42:07 -0400
Date: Sun, 28 Jul 2013 18:41:27 +0100
From: Mark Brown <broonie@kernel.org>
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130728174127.GB9858@sirena.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <1416484.XDfk5G56BI@flatron>
 <20130728131901.GA8864@netboy>
 <2529481.u8xHuXumcd@flatron>
 <CAKON4OzReTRb5JnJE+07vNJ-uDndLfqq8ha04J7K3x=WtsZEWw@mail.gmail.com>
 <20130728153546.GB5224@netboy>
 <CAKON4OzQ8BYuP00L6Ugt-tAteTdqqh58YuMfZCWQPirkGf9XMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RBD83sV6py9qOE/b"
Content-Disposition: inline
In-Reply-To: <CAKON4OzQ8BYuP00L6Ugt-tAteTdqqh58YuMfZCWQPirkGf9XMA@mail.gmail.com>
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


--RBD83sV6py9qOE/b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 28, 2013 at 11:50:19AM -0400, jonsmirl@gmail.com wrote:

> "furture proof" is much easier to say that it is to do. We've been
> messing around with the audio bindings for three years and still don't
> have a really good scheme. It is pretty easy to come up with the first
> 90% of a device tree. It is really hard to work out that last 10%.

I wouldn't say that for audio - we've got a pretty solid idea of what's
going on and little if any churn.  If some more of the subsystems that
we rely on were working well we could do a bit more but it's mostly just
extensions of where we're at now.

--RBD83sV6py9qOE/b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9VfDAAoJELSic+t+oim9SdgQAJl4Clxnxwb1rLY3PyDdaFeQ
7VOfJUOFcJp5dArSlDXkybhD/m6Pxg6tMNemvgq+JFO2SVeCx0I+0WliYNzwTWv8
GpH0L7Nh9DJQiFSU+8KAxAgPLTIPMs61edsIbjAlI/izth7Apw336sqL8JM4oaAG
O0W1Unp6BxWrP5J+iiJLa6kqkl1LjQuDBU+xKEKF0ZHwQkL1g56AKwgFz7E+qaRP
nsZee1cBPaDGjX5veR8tDXwIGHlp4jOvYX97ZiTgxe/2lWK8rslToUk5xEAr1kKa
w0UtfwDJ0LGkts/xwjJfvSka8LZq41QDObxuErc+NiI9PXk/HWTXQCzBojveOPQc
19D9nlkkHB58wB4pFaS0fNl3akT9IswiIU3okh6Fz24Xfz5U2KVX+s8b+G0UvVwJ
ZcE1Oi/TarOXeGvovy0CkcOuuv7gHi0YrKpfTH73nHpzs/s9O81wLcXVJzcvtew/
nuzMkjX6ZAi8DO6XAy1n7SPlrwp2GX5i0EaE2KqCo5JdHN/bqknIGnAENH6t+RQ7
DjEyiIfOrSQZmLsO3LHvQztx/YIAZFWLXEizoAz7AIHoQm3LdEUPqeKG6gh/rYh+
STgDtbQqrywZxqYHEsObdNB/4DWbvcuP7/YMavIn7fk0bVXT6or3Hq/svhRlni3Q
GJiyIULr7DGBaGlxMhZN
=bVx4
-----END PGP SIGNATURE-----

--RBD83sV6py9qOE/b--

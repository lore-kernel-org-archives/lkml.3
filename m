Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab3LXDjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:39:42 -0500
Received: from ring0.de ([91.143.88.219]:54128 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab3LXDjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:39:40 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 24 Dec 2013 04:39:37 +0100
From: Sebastian Reichel <sre@debian.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 0/3] DT support for bq2415x
Message-ID: <20131224033937.GB6542@earth.universe>
Mail-Followup-To: Anton Vorontsov <anton@enomsg.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1385311771-447-1-git-send-email-sre@debian.org>
 <20131224022048.GC10223@lizard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <20131224022048.GC10223@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2013 at 06:20:48PM -0800, Anton Vorontsov wrote:
> On Sun, Nov 24, 2013 at 05:49:28PM +0100, Sebastian Reichel wrote:
> > This patchset adds DT support for the bq2415x charger, which is used in=
 the
> > Nokia N900. The changes depend on Pali Roh=E1r's "[PATCH v2 0/3] Add su=
pport for
> > charging battery in Nokia RX-51" patchset [0].
>=20
> Patches 1/3 and 2/3 applied, thanks a lot!

Thanks. I will try to update Patch 3 at the weekend. It should be
added to the mainline kernel together with Patch 2 :)

-- Sebastian

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSuQH4AAoJENju1/PIO/qankcP/1uT3ZusKUFVA5gHkY4WXIi1
SQuuIbkjcnB+VE4VOA/OK330aqrcr9fIDNqUnFEW6/xHGbfmvoWmA8+M31n2j92/
ruqVzGkaAp/kjip+2dioQIwfsR7w78CioTUFbbD+akYzpNxiHUbWxAAy32ET9aFg
l3NFGtoiwfeULuJK5noVv0u257CCdVpjv7Z4rKkzenpbedHhYLEKDcfWglSlhoCS
9hh9sn05mA/+BkaTgqCNeYsn8HHlR4kiXQZCNi51lbVUaGm1lVC1+yUbDWOV4P+k
ECBsd5057/41D2kUu1olDYYHCvqQeobiliC5ztdaD8SfZ1HSR0guwYwKqK4pRzkZ
MDHsgWI952zYi2aVjkpXiza+y/VQotDt0UR8jvw18/Hz12n9yhep8QYttbSMmzci
9ye7ejFFfV9CcVAG9zAK58vlXFIaMugZ2Cqczol14/wnAd/X6AQ7iwrjwZpjtFui
VoBh8wSJrfy45vEpDr1Q1+4t88uxl1npGzZ0Iehi8aHGx+xEZTYT4wVpahod2t5R
Powh+6Ni/VoCTz1S6WfLzEAViQP9nxluB4Sjrjg+iAijgCiJ4lJK8oK1AtWXHKcw
WVpACIPQT2amykJuekzdZXyWmWyZ/FyxHUaQbT37mMQab+rCkD989Z6418MX2oUJ
uYt6CscW1zEJq/Bdb3w5
=D632
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--

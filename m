Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3KNXD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:03:58 -0500
Received: from ring0.de ([91.143.88.219]:57765 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab3KNXDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:03:51 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 14 Nov 2013 23:03:33 +0000
From: Sebastian Reichel <sre@debian.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Luciano Coelho <luca@coelho.fi>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Felipe Balbi <balbi@ti.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 1/4] wl1251: split wl251 platform data to a separate
 structure
Message-ID: <20131114230330.GB6383@earth.universe>
Mail-Followup-To: Tony Lindgren <tony@atomide.com>,
	Luciano Coelho <luca@coelho.fi>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Russell King <linux@arm.linux.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felipe Balbi <balbi@ti.com>, Sachin Kamat <sachin.kamat@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Luciano Coelho <coelho@ti.com>
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1382890469-25286-2-git-send-email-sre@debian.org>
 <20131114185132.GQ10317@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <20131114185132.GQ10317@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2013 at 10:51:33AM -0800, Tony Lindgren wrote:
> [...]
>
> If this is not going into v3.13, these will cause conflicts
> with the mach-omap2/board-*.c files for v3.14.
>=20
> So it might be best to do a minimal header patch first that
> can be merged in by both linux-omap and wireless trees.

I guess this patch is pretty minimal. It also seems to be acked by
the involved Maintainers, so maybe just merge Patch 1 without the
other patches?

This does not solve the problem with the struct modification from
the second patch, but I guess it's the more intrusive patch.

-- Sebastian

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJShVbCAAoJENju1/PIO/qa3ygP+QFNNsOwF5PZp0uSpTuxh3II
kdL4jIoihLkpJ1dgG6rMsJIqyHAk09XUd5TZjsKandyiv1XCSLzEbC6S3X6kBT15
/gxWHWUYMCDx7l21DFG5/zaEVCtGMalg2kxX9rClbcEdv1uJtVzw2qywyccWGNmp
N/D84+/Xu7P6n+AJvdJOMqGT1hMcerZCDc0x/8Ggcu9GMc+Ok6uYNwuoVPWhJbot
iP7+p9A+tz8n6RwLCmIF45TzDjXbx2dSh66qTChpV5LdOxunCXJe5GchEFbfAorx
3sEIddHZzC4yT3ArTqm/liyCIOUrVXcw0Hjal05XK+5lFKDSLZSGme6UTT0BzfsJ
wmrnD3Yo49PZrxYzfzonm8kpJ6YjHWX/b7kLQyY2U2W9f/StCE/WAwImp5Fj/SRC
ZthE7CNdj8L4OdciRSWgIrs8ttpkSIUhIkQ+0LZH6k/gfQWXD+uSdKJXH7zYnByd
63SgS+Rj9aaIpNyYTXOuWymeRFhh5Zw7wItrLxhZCZMOkcZ0fFMEqDo+zpNHCB4+
rblAhOdhDjJxpiOivWprhIUptYDl7VwePRG3XUrJaULDYM9S3rEY45MWCZ83QhkZ
xmSQm2t5voPfTvTnXKYZhj9WHdKGGCKz/sSaz2Y0c1cZ4qA5FpjKbVqPezovCvaM
rztAFbkFtnT9Tf9BvnZJ
=yaNn
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--

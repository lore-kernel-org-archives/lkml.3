Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3JVOo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:44:27 -0400
Received: from ring0.de ([91.143.88.219]:36648 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab3JVOoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:44:24 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  3.3 RCVD_IN_PBL RBL: Received via a relay in Spamhaus PBL
	*      [79.254.211.107 listed in zen.spamhaus.org]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
Date: Tue, 22 Oct 2013 16:44:14 +0200
From: Sebastian Reichel <sre@debian.org>
To: Benoit Cousson <bcousson@baylibre.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        "'Pali =?iso-8859-1?Q?Roh=E1r'?=" <pali.rohar@gmail.com>,
        =?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Subject: Re: [RFCv3 7/7] ARM: dts: N900: Add SSI information
Message-ID: <20131022144413.GA31867@earth.universe>
Mail-Followup-To: Benoit Cousson <bcousson@baylibre.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	'Pali =?iso-8859-1?Q?Roh=E1r'?= <pali.rohar@gmail.com>,
	=?utf-8?B?J9CY0LLQsNC50LvQviDQlNC40LzQuNGC0YDQvtCyJw==?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>
References: <1381091235-18293-1-git-send-email-sre@debian.org>
 <1381091235-18293-8-git-send-email-sre@debian.org>
 <5266742D.9050604@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <5266742D.9050604@baylibre.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Benoit,

On Tue, Oct 22, 2013 at 02:48:45PM +0200, Benoit Cousson wrote:
> Thanks to Tony, I've just realized that I missed all your patches,
> that for some reason ended-up in my junk folder :-(

oh :( Can you check why they ended up in junk? I would like to
prevent more mails going there.

> That being said, I cannot apply any of your DTS patches! What base
> branch are you using?

Currently torvalds/master with pavel's n900 patch and some more
patches from me.

> Could you repost all your pending DTS patches in one series rebased
> on top of my for_3.13/dts?

Sure. DT maintainers haven't given feedback since the last patchset
[0]. Do you want to wait for feedback from them?

[0] https://lkml.org/lkml/2013/9/23/529

-- Sebastian

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSZo89AAoJENju1/PIO/qanvYP/AziPMIxUU/F7i8hwk/TfJQk
XnTPEALj2pb0XWf53osh8BibTPNn++8BVlfb2b3NuZG3d726W6VLiAf3413C7d2x
Wz9zLO17X6oaxPIVwVSSPZp6cOAJorkzGQTkcQot/3bviWZ7+ALEhs1OMCk5oa9D
Xj0TOcm304nX+UzwHvEalrCIk5X0CbPXlYfx12qFh7v849+pXYuMOVM51H/65ipU
4ROjbLoxHl9l9k5PoiTQoHxzF3aVANbBpu8v2/3E4hfvwY7Pf9Up0Vc0vHFdQ6G3
G5CRNa3U2PofFNg1tgyiJHcnofmJR0BfsM3iIhw5IzO/hwOkTLT3U8uYH1hgeMP8
m4d6Gbmp/ufdcceuk2Pur3/k0eSHID52eVpdqEMFa/vIQDqCxO1gjk6/x6wypHkc
22JkkYu+33XiPPGWeONM1U9hgbyxGVIwAsHj92IW/BkgqBhDdQTBsSjqoPI/o12Z
6D95uivxW6rTrR8dmYehuElw4TJ+TzCZ7/ks4EXWzKwlHtSDqayFO1LlNe2f7qyj
xjwfTvWML5p2gO83pw+P60HUbo4IkGXIHY3tvpQhA5U7aPUQnX4X4i24f03G8Znf
VSvHjJDFg9irTdInwT9k+BCDsaIm3/nAIlDs/s8rfed/WkQDzp42rLIiy1q2xlql
Tyebt/6/MSY934V9p8ZO
=imvT
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--

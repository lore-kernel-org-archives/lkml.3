Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3GYTbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:31:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40842 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3GYTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:31:08 -0400
Date: Thu, 25 Jul 2013 20:30:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Domenico Andreoli <cavokz@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Message-ID: <20130725193042.GS9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <CAOesGMiLKysW2JG1jbef76Ves=-DAYEiE9d+s8YXWRXUJ+XhaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JpiLAyIKUr9Dcxlv"
Content-Disposition: inline
In-Reply-To: <CAOesGMiLKysW2JG1jbef76Ves=-DAYEiE9d+s8YXWRXUJ+XhaQ@mail.gmail.com>
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


--JpiLAyIKUr9Dcxlv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 11:25:30AM -0700, Olof Johansson wrote:

> To talk semi-specifics: What about USB PHY tunings for a specific
> board, where each of the three USB ports and their registers have
> slightly different layout? Sure, we can take 10 properties to describe
> each tunable field in each register, but at the end it will just be
> used to craft the contents blindly, so we might just stuff the 32-bit
> register value as a property instead. And in other cases we might
> indeed want to describe each property independently. Determining what
> is appropriate when is one of the most difficult parts of the review
> workflow.

There's also my constant question about why the driver can't just work
out the right value or decide to use the feature autonomously at runtime
- I'd say that the overwhelming proportion of properties I push back on
end up just getting removed and worked out automatically.

--JpiLAyIKUr9Dcxlv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8XzeAAoJELSic+t+oim9XXcQAIuXz1uFm2Q1x3hL++D8dSMu
8Ut3jCikWc/B/M2ozwlGBnzq0SHKI/HWGGgjHxvDngg8rxR9IjtEeosH2uOinIVQ
AgCN0I4SScRsX0iH2kOiWLFhHvtQgg9bfnMhC1FrKkqevjRfaTWoRWl0DMQ8i+hx
fMPVYhVKFqUbtDa/eLEGMmUIboO2Luqa5dfYh3hCFq3ReHV5F6ZFq+5pgY7tgjXw
k1I4Dyykvh+4AVGg3NKMSOyJOyZv0p349v2Vz/P/qjSaaCYpCz+6gyF7+IG84FwD
VmFRssOK89c8qYdSo/Ez/lcZ99gpIOwHQK1w5PHHGTxCvdBhuOBPJaOSRSXganFl
luQwUmSeP/Fj4rO466bVtwiSRe26hcZfLlZkufMLFbrX68Ckg872UiBvRLqcfNIG
gC0Ts25DsltfLsxzLHyW/Fj8hPcaJNZ25wd2PCpLC+QtbjHygfH62Wq5vPvXwBey
uk7we2NWWuUgS0mQqQ9aZHF9pwyEQY9enZvPiLFxf0P1eqZYmqHwePwg1K2OX/UV
n0E5ZCA6eN29qylwvgttFXVmEbQRlBJIUhsEJ3vWJZRI5MLa4wTEQn26Vc2nuf51
o57ZMvPP5cKXSg7eXAvh+9fTdddrBvAiX9p5RDl7xCSQaYEZ930q4lr42rZlRjWs
gxXSKEO6alYLIemSgIW5
=OK3G
-----END PGP SIGNATURE-----

--JpiLAyIKUr9Dcxlv--

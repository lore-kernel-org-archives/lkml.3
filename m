Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3FXQHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:07:55 -0400
Received: from sauhun.de ([89.238.76.85]:46531 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3FXQHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:07:53 -0400
Date: Mon, 24 Jun 2013 18:09:56 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        linux-kernel@vger.kernel.org, Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Kontron PLD drivers
Message-ID: <20130624160955.GA4651@katana>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
 <20130624120650.GC30838@zurbaran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20130624120650.GC30838@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I am happy to take the sub devices driver as well, although the
> respective maintainers can safely carry them as they all have a Kconfig
> dependency on MFD_KEMPLD. So it's up to them.

I'd like to push it via the i2c tree. Thanks!


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyG9TAAoJEBQN5MwUoCm2zTsQAI1WHc9L5jnOLbkPsNkuC77+
NxdPa+Wlu8gZ2jawddMbAxBXmNXAku/7gyN3ExTJT3ShLrSOpbRjT0KRg8mCpFC8
mfzAEdYj+JxwDEhZgCgYZQCoSPaQjrtgE3BmwHdOfYBEebjuEhjVCNndkk30t9BZ
SEoJMeIItRfBDOYB0EMBGmXM6kg7i+KsryzCCrC3B1riv0f6cDFy82PxKF+OpyL/
qCD9oTWb4cILEl1Jk5XWROdgR6b0xhTLPC1/NTNwNSaha2dL8o2Opg5KyaXYpCji
5d6Tn3nqAM5kHG96g4SjwR6rDUpFWkrMpYiBNzU99ScD9ob+rWbuHAUop0Hxpe6t
KN5xA1ijpaIdCxDzMgXFTuZyo0jJpBxfp2anpUHwJUhCqmBEW1F9H+nyov+T58yb
08yWctfnmdFL50AgYp27HTdx91Fzvl+r2qTuj00GgSKiP/hWiQ2OqJIoy/yQn1CK
qWoPSg47aoSUQNmK0jy5qucu7B66+BJdmCu7V6+it55aKLCxhV4k3Og9LTuPZm6N
iOVt/ccwglhjNYu46Uz9dO30CMXx13v1X/0geKhN1S1LYCUwZTJmUj2bHC1LtOuT
ehhWYjJbNKZkbQ5Gc9pvzmqkG/06MYXJOh3feTj+5XNPiJOUeyHd6KwXAecAO3wV
psmoF8hx9JEaasMKPot4
=ZVKM
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--

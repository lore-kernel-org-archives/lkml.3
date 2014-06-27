Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaF0P73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:59:29 -0400
Received: from sauhun.de ([89.238.76.85]:53374 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbaF0P72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:59:28 -0400
Date: Fri, 27 Jun 2014 17:59:19 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Dave Jones <davej@redhat.com>,
        Randall Spangler <rspangler@chromium.org>,
        Simon Glass <sjg@chromium.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Bill Richardson <wfrichar@chromium.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: cros_ec: Remove EC_I2C_FLAG_10BIT
Message-ID: <20140627155918.GA2637@katana>
References: <1403558406-14519-1-git-send-email-dianders@chromium.org>
 <20140627123443.GC29156@katana>
 <CAD=FV=WLw2D3sw2LaWt0SJXNEFSBk08eKOCa9O_zt=58UN+MLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <CAD=FV=WLw2D3sw2LaWt0SJXNEFSBk08eKOCa9O_zt=58UN+MLA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Thanks, that sounds reasonable to me.  Lee has Acked the whole series
> and Simon Glass has reviewed it too, so I'd imagine that we're just
> waiting on the input subsystem's Ack on a few of the patches.

OK. I assume it will go in via the same tree as the cleanup series to
simplify dependencies; if it shall go in via I2C ping me again.


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrZTWAAoJEBQN5MwUoCm2/30QAIUPL1T2DHZ6X5pDarXV5h+5
qv6vvhyZ7ZyFz0u2nrUL+SusOUc0CYaH+EQEcjr5zpKo2tMPSjFLrSMVsBjjhRWG
CFDTES7+sRRsirHwTUtKcYiENGXj2lNsyt9uDxGRh9UvJRcnyqg6Y3B2gE9BLPn3
j8aCrFiqXJr0UorWftTbpR0Pr8WHDROOdTrZ0ojN2ARnWqhFkcmiGjiE71uUCvov
GAPxhjI0jNgDwag0Tudgs8bsQWmNeQr0vlk2p5GcbLg33UmqUhogtaIxlA1O5tGj
yRuhB7YvnitYjRxgCKIY17rMIvTLYQjbQJHN48GHl/gtlTwXMt+/XolTNQQOSPUJ
hqXwO1s1Xvyd3vVjnCgwd+uOM0QHVQwkMuEWw4tv+kPK5ZvYjFdJw/EuzYTVeDIH
M/tHmuVCPLX/7t2cFtSXPS6ZqquS7I8QygJM38aCWARCY1sAEJHaE+AFNJEkpYS/
NDlw4xxO4IO86yjq88KV4hGyuZIEOfOeQkX4oRPOVoF0VLc/x4f9SSDLBglhg+RW
c99PxhYd2ewaEQcJlekrpngRSSi5FFwsMerybIa1oTZGv/CfsynRzBmEcVBijuVv
xHoe4pOBcRpjE03MecsPU2USKjmQL19llVbtAGFF9fu2b3NqwRuY+bubC4NxmuvM
TH9dT2KLHHkfKrHzEc/j
=lsS9
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaCJH0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:26:39 -0400
Received: from sauhun.de ([89.238.76.85]:51466 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaCJH0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:26:38 -0400
Date: Mon, 10 Mar 2014 08:26:31 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: nsekhar@ti.com, khilman@deeprootsystems.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: Re: [PATCH] i2c-davinci: Implement a bus recovery that actually works
Message-ID: <20140310072631.GA2571@katana>
References: <1393583525-9555-1-git-send-email-mike.looijmans@topic.nl>
 <20140309202841.GB2835@katana>
 <531D619F.5000803@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <531D619F.5000803@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I won't be doing those changes though. My sponsor's budget is
> limited, so I'm just having to do the minimum I can get away with.

Pity. Are you available for testing in case someone comes up with a
patch?


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHWknAAoJEBQN5MwUoCm21/MP/1Cw7Ur/bzgDWUsOi0SDnoPv
F5j13PsnZcrBRjWS0rOaWW5/9ISAtipZxGPAqs3b9AHlPQ0W2yhBMZwNIyLpggXM
N6IBbJwhbyz7q3SPcaVhpdxYNMcswhhPBO0zQwH4t5mr0wQVFDum5n/pQQ2Dfgm2
2pRtdw9IyyOVCUG243wJ5GDsT33idN+08O46LLTMRlo0r07mpeJ108uZQJfHtpfZ
HlNsoopVymyQDp70KP6cr+iDyXd3z3i7rG2H3KrcccGWQtL7dqE3QuO6BuSqCXJ+
Y4ex2Xy3jHUQRyNWp1xlBksWAUr+EUzUkeEqIteTeaVw/Krr/XhWfJFhPXcKH0OM
Two9QFRIFrNqv4CuFFxcZgrmJLy7o+zx3SFb/oKUd/yJGk+YhPruxfqIvbOdAhQ+
bx2YLeU0uMtkCN4VMFmQoxs3XhVPh2wus8FMOMz/aIvYYBp9aoXNyxjwy7e1RHBb
vJ0v9PSWLqqX/YJKYtkKeA5a7SY1Q2qKksS694X3jAAKx2deGuygFZkIMVlxMbDS
WNqAt1w0EedIojinzgwAUhSVQT8I0befWFE4V41uP3FJNMSvQuC9X9/S0YxMhfar
95gpz2bDe+Xbz43PzI+2geJ+1xmfTljQVRxXzrzMLxlloUsCd7gaT8wNLtYnISOA
HDKsPbe2cazXk2TgiHGN
=5m91
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--

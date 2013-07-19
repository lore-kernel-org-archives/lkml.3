Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab3GSSsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:48:19 -0400
Received: from ring0.de ([91.143.88.219]:52350 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3GSSsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:48:17 -0400
X-Greylist: delayed 2027 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jul 2013 14:48:17 EDT
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: elektranox.org]
Date: Fri, 19 Jul 2013 20:14:16 +0200
From: Sebastian Reichel <sre@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        aaro.koskinen@iki.fi, linux-omap@vger.kernel.org,
        lauri.leukkunen@nokia.com
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130719181416.GA1204@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>, pali.rohar@gmail.com,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	aaro.koskinen@iki.fi, linux-omap@vger.kernel.org,
	lauri.leukkunen@nokia.com
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20130609015944.GA23559@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jun 09, 2013 at 03:59:44AM +0200, Pavel Machek wrote:
> I'd like to convert Nokia N900 to device tree.
>=20
> Unfortunately, serial port is not easily available (very special cable
> would be needed, does someone know where to get one?)

One way to get one is building it yourself. I finished mine yesterday:

http://elektranox.org/n900/adapter/index.html

-- Sebastian

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJR6YH3AAoJENju1/PIO/qa4AUP/A/PMxO7JXevqRqpadVwUHWe
cqMCdksgCF+iMTnwmIl/s53Vx78qnL9PXHihxD4+BK+qO5ELX7zvliW0sT3LfjNl
lsKVMW58Lei2gNBAOWs8elcD0/0wrfqxlQNqOrBtr7NNyi0PCEkKxR+3GDjCByKn
zcgctecqfPjUhfTvHNKHGg+C9L2O2NoQOaUhH0obY5S8RNDg2th9ywQ/dy+cK6C5
9DPTnAM/NuWGkU9BrTzDHtq3zKsZqmGDK0q3o6HrrnI3yZKrWqX7015moeyu94/B
89OqvIBrj1nH1HZ+95ZPfbuvN8neRIL5ZM9JeS4n2cheHumoxjGIUNNRTrYkfEkk
0UvEe5xuWclS0B7TopzYozA6rKpJuRw5lroKf5UPMPU5T9C/plHysikYfTp2QHLt
ZYNI4yWKJL2KWKl1b7vsiTdfyFweRD4sCesnVS+NLxlhgQh3EnNatQfzbiaNHoyc
8hz4LGXyXNAyHQUPJC6/NpRsUmrGOHK7W3+SRWzWqZdB9NgCLGzJyPWW1aYoxKu9
yQ3iCzUN7Cr8SrQag2nwnXTUSOKCN8FYIdHtR3iUpMxwhGgif/2vFh7fX0RQ9Q7U
m3otvuEB5BUWs40ZcU4RwDWLDa+INk7A3PMk2sFzHcvfUFI63CHfMclxGwow8/BI
P8YG8dPzZ9WFNNsmWwR+
=jDnC
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaFCKwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:52:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51719 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaFCKwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:52:53 -0400
Date: Tue, 3 Jun 2014 11:52:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140603105223.GB31751@sirena.org.uk>
References: <20140528173858.GG5099@sirena.org.uk>
 <CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
 <20140602095112.GV5099@sirena.org.uk>
 <CAKohpom7XNFJ7dBzNVW0TX3gyxo4RJdJ4yriYLa_noforhyciw@mail.gmail.com>
 <20140602100201.GX5099@sirena.org.uk>
 <CAKohpomj5-tHPkBLMrgGpsDCaCxW-8hGMunMTmJgXGgEgTR=vA@mail.gmail.com>
 <20140602122332.GA31751@sirena.org.uk>
 <CAKohpo=vPojhX_9u6Coa=2Kiu0jY9hCTg2B0WiWfJS8ZQxK4Rg@mail.gmail.com>
 <20140602152014.GL31751@sirena.org.uk>
 <CAKohpo=4gY42TJ0CcUBarHRnUvFKkXTykTYCfGUnAZ+CFwYE9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4rQ9lIe3OahbhU4J"
Content-Disposition: inline
In-Reply-To: <CAKohpo=4gY42TJ0CcUBarHRnUvFKkXTykTYCfGUnAZ+CFwYE9g@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4rQ9lIe3OahbhU4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 10:25:18PM +0530, Viresh Kumar wrote:

> As Rafael has asked you to apply the patches, can you please apply
> patch 2-3 for now?

Not right now, the merge window is open.

--4rQ9lIe3OahbhU4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjajkAAoJELSic+t+oim9Ow4QAIhWWs6UURz9kji0vixZ+C0n
J7vE1ecXtBRDehYtogFCPra27e+IDwkNkqyoO5U/4Uj9Bh+xYrQRzG/R60hCYi+0
kcRkcASxKGF6ILzMft+kXjFp/wuZnVyfUZFGRZAnkH63XUCln7WotRz5Ra184icx
ZBXwxIf5OHbq+0/7m9q0Yl1VO1th7+5XsiEo1g3WCinKXi8CSOgcPTsLuHBADOAx
RQwh9nos/cHtBl3shKtvJsqDhjv8DYxlwH09w7ChwsGsV2ddXnLi6Hw08xiPVsD7
2BSON2f96e5gwewNqRAXTF3kejBhfc+/gx6YSCcXXWgKyQS/M8ncSmHxReDjdl9c
3ekRNJ9HeoA1+iXxmYx76+p2muKKsNZD9BkmZwMG1lrQOaC3mRn+LCGTXLJlcu5a
IjHtPKgFyHMaRYNZ2HWymZZl3zbWYZuSZtWEvs2/l0Th07Pu+UhmK8qmcIBnamtw
HcyMh7BpMYsaq2pDTJrMaFGuVK67Ya2W0WMMLW0STIwo9QO807doi91wFujd+moL
v+ZCe4UHhVUCpZB6NYUAuducb0lhRLycErana0wRSBvGyBNcnTpOaQco510Bo1NR
y1AojI8Cv+ltQvWxDetRVlMZ73JB260ze3G3+n0nfMuVIH5q6H1VQVUs+XWcS9G6
jlRknsEY6qbGoaS0fQL0
=+Scx
-----END PGP SIGNATURE-----

--4rQ9lIe3OahbhU4J--

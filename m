Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbaGUPpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:45:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48021 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbaGUPpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:45:01 -0400
Date: Mon, 21 Jul 2014 16:44:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <bcousson@baylibre.com>, Charulatha V <charu@ti.com>
Message-ID: <20140721154442.GB17528@sirena.org.uk>
References: <1405683053-14104-1-git-send-email-LW@KARO-electronics.de>
 <20140718171035.GQ17528@sirena.org.uk>
 <20140721075144.251bb67d@ipc1.ka-ro>
 <20140721121820.GW17528@sirena.org.uk>
 <20140721144104.5e37f1a0@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YOxyDEsNCn0QNWql"
Content-Disposition: inline
In-Reply-To: <20140721144104.5e37f1a0@ipc1.ka-ro>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap2-mcspi: fix blatant abuse of the resource
 subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YOxyDEsNCn0QNWql
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 02:41:04PM +0200, Lothar Wa=DFmann wrote:
> Mark Brown wrote:

> > Just to be clear the issue is with the presentation of your change, it
> > is not appropriate to provide a changelog which consists mainly of
> > widely directed personal insults especially given that it omits basic
> > technical content.

> I understood that, but I feel incapable to come up with a reasonable
> changelog for this.

Just describe in a specific, technical fashion what the problem is and
what the fix does without reference to personal qualities of the various
parties involved in the code being the way it is.

--YOxyDEsNCn0QNWql
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzTVnAAoJELSic+t+oim9JSgP/1YbQarKbfq0/M89Klmqnvf5
CVXLUgVL+EPAAI9UEDn6+53S5OqshLAvtD5/4KU7FWxIwyT+DP0eKTespp3O+nMb
J8gHuG4KevPqzoJi8xmuZGCff3QCA4LPY1S0UUk3sYQ6hTQZzdP1qJjxgHytTDUl
n2u24e54PtqmsubcPuYFnhUIvK2t57j4U7dY1hYbot5zOMBBubwvEJZ+TJQRa/xN
/kymMpiO+1jFgTTatqARQmp1abI9TeXZAm6071WBzm0T9lxshKjW49usT9TBVvqv
+ZkadN/n+rBfv85xaBOJu1H0/mEh1wfceirndoqzDkCKoe0Y2dtnVZ0qun9MUJIB
qQKyXwNOPRkp1Oe/9qjz4twDlzfeyCrNZvLnQ7Ez0hPmxmTuE84qjeVKQfcmFHJ5
k6e0TMOvhaPp1y5HiXMgjPilHDlHC/0hMl8PE2trrOA83tFL+CIuBB1B1FuqWp3p
pTa+3WizSC0WK+5LXbFHtlOkcOdocTdoTLLD5ESOYqP3CB9AGQUghWNWJN8s/Bd/
BbyQA3APGRo5XjdZepNDgqIdIEYYhweNZqpV49jzuCdQzGDM/dZK1P28EkxUuHap
1q57uDphql+FWObGg2whYBvzEm6Qm5u6dQf4c4eGQ2eU8n3b3EBKYNID7uPYxGWu
2KJlnYG1hpfxBDItg0KC
=xbpx
-----END PGP SIGNATURE-----

--YOxyDEsNCn0QNWql--

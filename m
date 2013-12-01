Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3LALaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:30:17 -0500
Received: from ring0.de ([91.143.88.219]:39352 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab3LALaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:30:14 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 1 Dec 2013 12:30:10 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: hci_h4p from linux-n900 branch: fix with new bluetooth for
 3.13-rc1
Message-ID: <20131201113010.GA9213@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <201311271559.21855@pali>
 <20131201104839.GC7403@earth.universe>
 <201312011216.42192@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <201312011216.42192@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 01, 2013 at 12:16:42PM +0100, Pali Roh=E1r wrote:
> On Sunday 01 December 2013 11:48:40 Sebastian Reichel wrote:
> > While talking about the hci_h4p: What's the status of the
> > mainline inclusion? I saw, that you sent it to
> > linux-bluetooth guys some time ago.
>=20
> Yes, but code needs to be changed... see that thread.

I only saw the few small suggestions from [0]. That's
why I was wondering about the status. Have there been
more mails?

-- Sebastian

[0] https://lkml.org/lkml/2013/10/24/375

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSmx3CAAoJENju1/PIO/qaoh4P/jV4T8EOvPM7xcngnYuGT8C1
qnw2BOocwPur+n7Im4RgurJr89nRk5iFL6PDSCzRvgDAvBVk84k5FHJRYTaP4ZUQ
EKF8erLpHDpnJVSzdUxG77AoVEHVflR3kK5voI4EKlby2yeVY4NYVRb9XzWASw35
U9J/xXqRKMuqWKB/G48g7BBWKvIZcAde2MCa76AtF8ZHQfaDPby9gxVXkYfOKL8r
wvGoqziBikuuBtDAVklTnsw24MirJIemS4eOHwcpiayKyVGzcuRMwT2oHDmwA+iV
Q6bXjPi4YJQTrKtbj2RHGAADmw/SyF28BsowZeA/hvZJawBiLLjbZ7bvY5rp4Y83
bQ23aNRDYj92EmUarITUpU9HAlE+Pxdvw+ysKe7AOSussTFWxqQhSSOuSUdUiH5T
jXh/oggEVrXpSERHGyo1q9stIBh+cHH+IDT3tt3PqZCwk0ryG9bKhKX9FeIA+t1d
Y5FUlyrRHyRxICfPoBSDIz8e57lfXU852WiUuvQd57/UqIukmnpjPOAEPp8/4ZlR
CXtH3n+RFTmydCPr7TWpPgxmaOcst5vteliCXKXIVXqKS8m2J82NFkqhPfPySAaO
DONBA6d7bsGsbtbCxfoJ4hMsvTqXmkYSjrYE7LFOjRFb82gzMT09tWp+df6GgBP+
4xGzG+LXtaff/Uzh+4qZ
=zKx1
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--

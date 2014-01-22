Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaAVOFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:05:45 -0500
Received: from ring0.de ([91.143.88.219]:49832 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbaAVOFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:05:42 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 22 Jan 2014 15:05:14 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>,
        kernel list <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv3] dt: binding documentation for bq2415x charger
Message-ID: <20140122140513.GB17251@earth.universe>
References: <1389393286-15263-1-git-send-email-sre@debian.org>
 <1389401268-15069-1-git-send-email-sre@debian.org>
 <20140121204803.GA853@earth.universe>
 <CALT56yOZ5qCoS-xwFV7sqE1LATQUFckOkQa7dd24Foq7A4Xv2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <CALT56yOZ5qCoS-xwFV7sqE1LATQUFckOkQa7dd24Foq7A4Xv2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2014 at 04:07:25PM +0400, Dmitry Eremin-Solenikov wrote:
> On Wed, Jan 22, 2014 at 12:48 AM, Sebastian Reichel <sre@ring0.de> wrote:
> >> Add devicetree binding documentation for bq2415x charger.
> >> [...]
> >
> > I've seen, that you just sent a pull request for the power supply
> > tree. Can you please add this patch [0] and send another pull
> > request? It should go into the kernel together with the bq2415x DT
> > support patch!
>=20
> If that is fine with you, I will add this to a 'fixes' branch and
> send a pull request somewhere near -rc2/-rc3. Agreed?

Sounds fine to me.

-- Sebastian

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS39AZAAoJENju1/PIO/qaU0cP/iPOHi56n+CRCaJlzohlrSH7
2pk8kX0fCxY1Ob9GQzAase2pzs7FyCHAucejJ09GAupFOy2x9X2pqe+MzgxU+2Vv
Q4PCZsHpGv4gthL2orl8rwchO5NWDpqqXk+vUOqBBEZhQqiWWBWssmpQDpdXc5+t
vdQ03fA586SAuy4ooGWFMlOx+NB9uNp3Zy+cAkmPlIuLyuFQML3aTtfQ8sGyC/T7
Zor0aTqwvhbjtHuueSrOuow4P2KvlDoOWwv1+dyZojdfQgVuhVpjvwb0bKg9muw+
fhra+RPX3UEN2Rp81QmvcByXCZPJfCw0iBwkFaUBADNEP6R6mYRzzSaXaXfh4Asv
WKRlYyaoki2vh7a55DQhk7LLlkzC8n+kLnKOCJIJfV2FLhm1sHkI4HIDtIpRRbpJ
/RlmrAfeDrkKOUxT+RQuObs5N/x/z6J4lF4tkkBMf0Fstd+SuEucQHMHNi8UfRX+
JjPlcEXS+AlZ09jCeqk41QKKG5gi/Fg7SzUMakIFhssld1VuEJzzru1J6arO4jgl
gt0gPzlRxem9uqcpbW2+BsHaHQ6zM8eahBeZjdGnkP9/TisOa6ur381tXtJiOTp/
RKhvS/bxgbvK52IFxTp183fp2CMafKHU5q6xKiJ+9c2DErZ8UVVRcxHNz/1s4UAE
5wFY6qpcLjmS6bpdwR5l
=KSCn
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--

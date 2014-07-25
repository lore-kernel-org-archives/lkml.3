Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbaGYKjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:39:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54388 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaGYKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:39:35 -0400
Date: Fri, 25 Jul 2014 11:39:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Michal Simek <monstr@monstr.eu>, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Message-ID: <20140725103905.GP17528@sirena.org.uk>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-10-git-send-email-afaerber@suse.de>
 <53D20A61.1050506@metafoo.de>
 <53D21066.8000905@monstr.eu>
 <20140725101815.GO17528@sirena.org.uk>
 <53D2324B.4070602@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XqFDY9bHNWRmuMQr"
Content-Disposition: inline
In-Reply-To: <53D2324B.4070602@suse.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 09/11] Documentation: devicetree: Fix ADI AXI SPDIF
 specification
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XqFDY9bHNWRmuMQr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 12:32:43PM +0200, Andreas F=E4rber wrote:

> I used scripts/get_maintainer.pl --nogit-fallback. If you were not
> CC'ed and need to be, please submit a MAINTAINERS patch. :)

You need to think about what you're doing when you use get_maintainer,
it gives both false positives and false negatives.

> Maybe this works for you?
> https://patchwork.kernel.org/patch/4620191/

> Otherwise I can resend with Ab/Rb.

Documentation/SubmittingPatches.

--XqFDY9bHNWRmuMQr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0jPFAAoJELSic+t+oim91qcP/isi2MsxkEcpE869c2mD6n5M
0159BsrMF65Qy93w1RH4mO+8nmIuImgiqfU+8yrIk6oX1BtLNCYPlhxGi8SOfOuA
BJD9AQnWiZvrOUuwdBDNnc9hcpbbd2EpRfKAqdRvLlPogLJr67tI5bggkB4DggME
rhOna7CkF6WwG13YZOeVe/FaLfpvdbgm485f5MuWqLDv845veVdEGMGYQ9IwPkbH
JnTdT007jOFccrxHtXwdKMti+659cfzsu5WxCtBeR+Dd2adVTCyjqkVIhuZfLvhQ
9M0yWAw5OzwBD3n3Tr4vVxonqabeKk5Tk2iIYx3rUCslUa28BdGmERJ+AhRwKF94
k8VO0ZHs2aOdznw8qP91ESMr8FoW1l3wBhN+zHx+cqOvCg/GkLuf5BIUl23+w9xl
SaM2OcR951tzhONHKrxJo8lm40aMGnDcl1nHVUiJqeKYKSEw2fqhxnlY6BXZ6vve
kVY26noB+YUmNkjdljmayuDVUmZjFUkwpNyb21gJop3WurRRCmXmGH/8PEijFUcw
R62plRupmEZ002SDj+aL7GeZb13PYHtooYP1Np1NhEt6avv5CZj39XzHeXylzWVp
OfjanWt4b3R4MlW5/xmDkX7sOZMh3NwGeeDK2gXIr9U7Pq/rixy/b4kXBvtDY4Ut
PMtwQqXm8KlDiBvJVofE
=8NFN
-----END PGP SIGNATURE-----

--XqFDY9bHNWRmuMQr--

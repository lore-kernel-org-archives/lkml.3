Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3GYUFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:05:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3GYUE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:04:57 -0400
Date: Thu, 25 Jul 2013 21:04:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130725200435.GW9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
 <20130725193135.GT23879@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GMTE8OfInQq73BD2"
Content-Disposition: inline
In-Reply-To: <20130725193135.GT23879@titan.lakedaemon.net>
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


--GMTE8OfInQq73BD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 03:31:35PM -0400, Jason Cooper wrote:

> I think the idea of a 'tentative' directory (or 'locked') is churnish,
> but necessary.  If I DL'd a tarball and had to type 'tentative' to get
> to the binding doc I wanted, that would be a pretty clear clue to be
> delicate about how I trust/use/plan with that binding.

Another option for this is to annotate within the document itself.

--GMTE8OfInQq73BD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8YTQAAoJELSic+t+oim9SpsQAJdaebAfkVqU9aNpgm/ML38c
8tcLt4J58K9RIp4zr/4V+6Ts2R7/0RXoEkUpJ8+XqEL6oJhpNk6TszUfFLHE8OUB
AeVaf3sGncXIUnb+0OG5rvPUrgsy9oPU0dyPI4qcy6m9NVM/7VecB7hmAd1JAZV0
qofc18GntAV5TEmptpH04ptNeslX1T0/GDLo8XVyZvZlXTxCjCQhQao9dc5fZcvr
8LcEA7gQkExWgUxRN/HVlci52i0zVqgNCQt7Uhb+ZQaJYUDUt2A4W913eiSixFLF
QTOjq8bEAl0L+HjWyhgrlVtfZm0RuG7zL7cGCB6A9CqcADzTNfQwYrO9ckqRm+u9
pd+EfDMkttQ3zvh5u8P1gm9oZZaW6WZBJhR1MGgwJ0GEH57V5arpZ0gGcJWC1ST2
jdYJkVnScBKaK3wzLogpRCdrbJ5V4kpmnb7qnkcqBXFoOGMrux4p51A8WqC6gA7d
LjLtf5CHc9LJxFs0n2cyPTJtTh9IIGx9erIEDJ1AfUcVk3Br5myxB0AVTYX68grG
bqFunEWrTc3cZMQcqdiBXH4X5eRRJ2nRiUlkSJ8M/q2H2tRXkeACKNiEFb6acFAk
YsDrWYF3UhOyaY7uptznHqZ0D4K7FekRrhbo/uW1f5J5sUkpxk+RU8OCWb42bsj5
UXbyt8uppRBqeH6SjubN
=gvs9
-----END PGP SIGNATURE-----

--GMTE8OfInQq73BD2--

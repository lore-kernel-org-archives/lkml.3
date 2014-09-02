Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaIBX3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:29:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47159 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaIBX3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:29:34 -0400
Date: Wed, 3 Sep 2014 00:29:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Foley <pefoley2@pefoley.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Message-ID: <20140902232906.GG29327@sirena.org.uk>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
 <53FB9DA0.7000301@infradead.org>
 <CAOFdcFP4b0YFMuUFKm4=FoAGbCObf4u=W0UUPwf-ju_TNvuJaA@mail.gmail.com>
 <540651B3.8030400@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6u7lpXof/8C/+w+8"
Content-Disposition: inline
In-Reply-To: <540651B3.8030400@infradead.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6u7lpXof/8C/+w+8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2014 at 04:24:35PM -0700, Randy Dunlap wrote:

> I guess the quilt patches will be back whenever Stephen Rothwell is back.

> Mark, do you have any ideas about this?

> Importing jdelvare-hwmon based on 3.15-rc7
> Unknown BASE
> Importing rd-docs based on 3.17-rc1
> Unknown BASE

Your tree either wasn't in the control file that Stephen handed off or
got eaten by one off his scripts for some reason.  I've tried adding it
back, we'll see if that works tomorrow.

--6u7lpXof/8C/+w+8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBlK/AAoJELSic+t+oim93h0P+wa5T68TLpsUYi+MVJVL0X+j
qzjNSWHbwz3XXXdga1RDkOotGIbQyEkuXFLaHrf3tG84mD54+l1hmfcO+8yEpMEP
68BR0Dxpezdzauorc3wkOFpZVRtVQt+n6vTxFzZAiZdISVKLatZmbrtTs8CqK16V
5gZvXXCFlVDb4KGZKtoVeMVq256BT8LTWvMBjIO3W14zwsVb0XLueMco7L9zRmOI
DQ/K6+wsHkkR99o6CM4bA4b2EtMxxH3y3ZwOdEbE5NGkTRZiAhGannQkD8uFv48W
fC/ahkTpGcfimGP/qiJTCijOthCWRZ7JlY3dGB1Zp6hc4cEJA2d6FnUBq1TQQpMK
dMcYzL9lcoSJjMUII2uA6rIh9a36TAqgszG2X1Ila7yNNMO+MwZbagVx+8EoxHgq
CFfWcM8bSx+Bn3BP74hn/HlU7hxxUphvhS6Vo0uAZIDyAcdyi8rtCpRFiQGMrs+S
WnlLAx1xAY8U+XqrNpD8vfvkeTmujcDMlh3MzDfNj8GTUhPwwSBKLqC7fRwY56JB
MxZJz4R5eAH5TzM7N8EHbeBNMG4UN2kgPSiySTjxqka09YXcsJvwRTambh5qY1Yn
U147T7C/g8npLWUlrCkplZniqsHrNnh6UziQifJgmd7OL5jN8EVqZEokvBT+dGbc
EQCwJ+jgRy5/dLxR5PIi
=61sq
-----END PGP SIGNATURE-----

--6u7lpXof/8C/+w+8--

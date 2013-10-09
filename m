Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3JIRuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:50:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49952 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3JIRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:50:07 -0400
Date: Wed, 9 Oct 2013 18:49:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20131009174939.GT21581@sirena.org.uk>
References: <201310091646.r99Gk3N9015896@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ca+s3PlhHV9xbzQQ"
Content-Disposition: inline
In-Reply-To: <201310091646.r99Gk3N9015896@swsrvapps-02.lan>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] Fix Regmap Block Write single-rw Mutex Deadlock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ca+s3PlhHV9xbzQQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 09, 2013 at 05:44:38PM +0100, Anthony Olech wrote:

Applied, thanks.  Please format your patches as covered in
SubmittingPatches - use subjects appropriate to the subsystem and keep
noise like the above after the ---.  I've fixed these and the strange
capitalisation when applying.

--Ca+s3PlhHV9xbzQQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVZcwAAoJELSic+t+oim9KuwP/0Z0K1wfeKaEHUlwLZVa6f0K
bCWDugrPaN/EOxNYLwsIkUK1NcKErCfbgl6RE4NjH0sxdVImsGs3MO9Mw7jpTnQP
xp+27U4GviW9rJf+bin6YJBJnLPF9qWH4KLiXV+6/NMfnX0MTOhocbE0jtdzsJyO
5DZ0K6VU4IuSA9UDk5WF42yqd2YItXKLGDEBQ5AGUuQCQHpJs7wx86Dudi0VZwZT
/H0M6VZ/fVm8h+K239ulsJ9lSFWCmSvVgGjQmK3pFJ2IOllst3GOCg1jg08mxZI2
8gfhsz6YkAq/jxgGiX40c47SO3NrctevjGa/YbCDitrtFEcZUeNhWNHd1YTYaAAH
5YzyEKNRDyexqoTid2qVO51O95OM4HWSvjhHm6Sj6kaI0tUNlKum0LcFI/h0tCzr
vPPq/pN6aZg23nk4vBcEH1z0BAcdtYN9EU5qymrqssjNeZ1Ghd8N5zvufx/ecIkg
fOnAtUtcKqxMgDpmi4egMgRsZZKYM2mQjkLi+IWgQwFOOYm/EQZAEVEp2Ycynxci
jA3hj2c4acTjZhJDQKj3RFFwTFLJj8BC4V5Xmce3y5faurMkNu5P6n/bh/Xweqvb
Z58uaK+v9mNpzRzlqjz5jQEWog5OhQZ8CMPaoicyzDDUNBRA5sQTI1rOy36u/gJU
yY+IYNPWdzm7zyHYA0qT
=wRaj
-----END PGP SIGNATURE-----

--Ca+s3PlhHV9xbzQQ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaGLCJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:09:29 -0400
Received: from ozlabs.org ([103.22.144.67]:37927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbaGLCJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:09:27 -0400
Date: Sat, 12 Jul 2014 12:09:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] serial: imx: Fix build breakage
Message-ID: <20140712120919.22f0ab86@canb.auug.org.au>
In-Reply-To: <53C096D0.3000005@infradead.org>
References: <20140711112108.7631911b@canb.auug.org.au>
	<1405046206-14495-1-git-send-email-peter@hurleysoftware.com>
	<20140712004248.GA24760@kroah.com>
	<53C096D0.3000005@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HNwQ9DoJp+cwps1IO=9wNwk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HNwQ9DoJp+cwps1IO=9wNwk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Fri, 11 Jul 2014 19:00:48 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> It's not clear to me that Peter forgot it.
> Someone else brought this up -- it seems to me that
> Documentation/SubmittingPatches is a little too strong about needing
> permission to use Reported-by:
>=20
> If this patch fixes a problem reported by somebody else, consider adding a
> Reported-by: tag to credit the reporter for their contribution.  Please
> note that this tag should not be added without the reporter's permission,
> especially if the problem was not reported in a public forum.  That said,
> if we diligently credit our bug reporters, they will, hopefully, be
> inspired to help us again in the future.
>=20
>=20
> Sure, if a problem was reported privately, then we need to have permission
> to use Reported-by, but if it was reported in a public forum, that should=
 be
> implicit permission (IMHO).
>=20
> eh?

Yes, indeed.

Just to be clear, I hereby give my permission for the addition of
Reported-by: tags with my email address for anything I report
publically or privately.  :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/HNwQ9DoJp+cwps1IO=9wNwk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTwJjUAAoJEMDTa8Ir7ZwVLpMP/0HAIs2GA3uj7G1JuC+9//DO
SZ/lTcDFDC66oHl5cNe4NHEd3sJTTVJxMTQXofqcS1G8CASqbwjUc6/2TXU/vbz/
JILgJajooM9kS4t64SK/Qj2660xzEmufsem8Kk4Fd7QjeWdsIpkd0zvKJ5CtyahY
tn/vrWjZ4j258JxNPq3a7KB3NGVEPEX3zNY61lppaVyz7f8+5WGFuxreMrQdcTnL
C/3X00jQNay7FDw7lr5OGwBMZs4wySbdz2+qjGCrVt9/G+vYaqtVd7j695HS3ZE4
Pc9GsyUMx/OUirzRs+PNftfAYyanznpBQX6DAL3dkutWrG+PwAuMBTFF9tZJYN8P
iuh2sQZNwZpPEXInpEWIDoedsVb4dRpBxsuI2wdtGEc5pWyYJE1dIONEoqdlfP9r
f28a0SGY9Mn2+FK/jHTP+GJTwT6H2zPg41VBNIYgqLaFdLSxOgL6grNZbns/TCHm
4fVzbG3HmCHiKUKa4D+PafaNVdlM6arEAqG1CjI+/mbraiTMPbtoWTAxOddVGxpd
nyjUjpxdzvsZ38zD6Kpu35urvwJPH8SBoOnDjbZnbHY34k45po3HjY12NTV62wUX
wUe0RbQgXjxwi9ANOHjZt5nBkZi+dyIM14TLiftLcCV/3S1kK/+H2I0BxOfPe6us
vJpmI8wgpyf0njXp1xhY
=Kbr9
-----END PGP SIGNATURE-----

--Sig_/HNwQ9DoJp+cwps1IO=9wNwk--

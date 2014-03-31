Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaCaTrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:47:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40556 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbaCaTrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:47:31 -0400
Message-ID: <1396295230.1241.49.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 153/200] powerpc/le: Ensure that the 'stop-self'
 RTAS token is handled correctly
From: Ben Hutchings <ben@decadent.org.uk>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 31 Mar 2014 20:47:10 +0100
In-Reply-To: <20140331024050.GA8915@thor.bakeyournoodle.com>
References: <lsq.1396221814.369444335@decadent.org.uk>
	 <lsq.1396221815.799153951@decadent.org.uk>
	 <20140331024050.GA8915@thor.bakeyournoodle.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-opw0crCPz4PjovXbFTyG"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-opw0crCPz4PjovXbFTyG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-31 at 13:40 +1100, Tony Breeds wrote:
> On Mon, Mar 31, 2014 at 12:23:35AM +0100, Ben Hutchings wrote:
> > 3.2.56-rc1 review patch.  If anyone has any objections, please let me k=
now.
>=20
> This patch doesn't need to go back beyond 3.10, so it's safe to drop
> from your queue.

Thanks.  I skipped some other little-endian pSeries fixes but missed
this one.  I'll drop it.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-opw0crCPz4PjovXbFTyG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUznGPue/yOyVhhEJAQpjJhAA1Xu0GW1WpQ0Tlja8Vr5MO+/Rec6nXIt+
PEG/hji+eNCLrqTEabjdNBP+1bTJXrDX9KFbxhXhu5h8N+akizBq85nMKobpLM7Z
8mt9nD4gMPumjxt1j+TAtnhGoldzbX/LZkGbUtXlj1t4IAqDhm3PMeVhWeYv/rM5
fHU8wdVrnzqWV4rpUuKrNwaHq7i9AgARoGEL8kzMG37BUPsRFeIfXnTBGXlVQEED
gZQV89YSkai2SpxbMfWDLQaU013pJp6vvmba3nW48N36ddGOUm6cPiMsm81KYxkV
BZsAq9+hL42REQGpNFecCi2cXj1q35YvKAZTWAxvI1gZZ+yjs3azMhqE/XIE+Y0J
0+spOjFmc5hNlA691CkBJ7s2jU5Q5XOr6x44ArV2HVfOMU2Fzs5VbGDKRUZ85God
nSJKEPuiYx3r/FX1fSxme4tgaLPRqXcJxDfAYWfORMtKhSeOnPBRfwUWyz38Zd9b
5Y/thsqmGzm6p0BwAPlizbX9qEpG7xBLk9CsgZILQmtfO8Q43tRoV/E+g14UZJn+
TpBRIRt8QpfEuKdk35SmBL6jhRIdwA7QIH3ugjF5xzkaoE0xMcbX+bKSUaqyN0J8
OuQ07PtEyn9ENQwh+dt68BTw4zJxSrk0KB1dCJvhoErvlb/S8fgNHzOEXjDIk1v+
aBTvzkH2cRs=
=5hpp
-----END PGP SIGNATURE-----

--=-opw0crCPz4PjovXbFTyG--

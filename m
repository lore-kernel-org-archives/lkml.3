Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaDLBei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 21:34:38 -0400
Received: from csamuel.org ([74.50.50.137]:50357 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaDLBeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 21:34:36 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 21:34:36 EDT
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs part two
Date: Sat, 12 Apr 2014 11:27:17 +1000
Message-ID: <349322773.2UnfDfS622@quad>
User-Agent: KMail/4.12.3 (Linux/3.11.0-18-generic; KDE/4.12.3; x86_64; ; )
In-Reply-To: <53481D52.5070608@fb.com>
References: <53481D52.5070608@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1920327.3zycuAbs5t"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1920327.3zycuAbs5t
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Chris,

On Fri, 11 Apr 2014 12:50:26 PM Chris Mason wrote:

> The most important changes here are from Josef, fixing a btrfs
> regression in 3.14 that can cause corruptions in the extent allocatio=
n
> tree when snapshots are in use.

Will these regression fixes go to stable too?

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart1920327.3zycuAbs5t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAU0iWdo1yjaOTJg85AQLKJAf/QzwnX6m/vN9k+Ac4A2YLYF972WhCWbr1
qcdADdEsqrXNFaZWc8ukwgKl1DSoGC6zJDevmpLwe8ISzzXrB1r6hN1RQK3TjTBA
VtaTRqk4pdj+k0wt1y04nN1/6n36aUGnp1yH36H27laKQQtx1JbRCX6On+pFQZE7
cR8RkMPxoUZ6dQ148YqDxWVCxpGLmtBuBE+B527WfFceavoYUDVM1AWyEKZ0pVsl
k6x50V0C7EM2NRj0hq/5Rp/v6paw1KxjoRjsN0hnpFg9WqERIEII6lVUihv/Lpit
m1qygohYduqTf2yWpXkY9Y5RwesaWsrsOBhL17v02WDt0v/svWKXpQ==
=qYVc
-----END PGP SIGNATURE-----

--nextPart1920327.3zycuAbs5t--


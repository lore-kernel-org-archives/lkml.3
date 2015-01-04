Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbbADXDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 18:03:51 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:51053 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbbADXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 18:03:50 -0500
Date: Mon, 5 Jan 2015 00:03:48 +0100
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] Fix error-code overwrite bug
Message-ID: <20150104230348.GG4806@salidar.dom.custoft.eu>
References: <1420394662-20011-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zs/RYxT/hKAHzkfQ"
Content-Disposition: inline
In-Reply-To: <1420394662-20011-1-git-send-email-me@mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zs/RYxT/hKAHzkfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 04, 2015 at 19:04:22 +0100, Giel van Schijndel wrote:
> Don't overwrite the returned error code with the boolean test used by
> the if-statement (otherwise it'd be 1 or 0 always, 1 in the if-block).
> ---

Forgot to:
Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"If debugging is the process of removing software bugs, then programming
 must be the process of putting them in."
  -- Edsger Dijkstra

--Zs/RYxT/hKAHzkfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlSpxtQACgkQZBYm/87l50JiwgCeJi8kTE/RgtKtdfghcRjFXwqn
I/MAn2aLKqQNbYK6B3zcj04xDxXR1zM8
=Xi+e
-----END PGP SIGNATURE-----

--Zs/RYxT/hKAHzkfQ--

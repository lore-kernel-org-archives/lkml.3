Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab3BVRSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:18:10 -0500
Received: from mail4.gandi.net ([217.70.183.210]:50427 "EHLO mail4.gandi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556Ab3BVRSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:18:06 -0500
Date: Fri, 22 Feb 2013 18:17:54 +0100
From: William Dauchy <william@gandi.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: William Dauchy <william@gandi.net>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ian.campbell@citrix.com, david.vrabel@citrix.com,
        "Christopher S. Aker" <caker@theshore.net>
Subject: Re: xen-netback fixes for stable 35876b5 3e55f8b
Message-ID: <20130222171754.GD27794@gandi.net>
References: <20130222164728.GB27794@gandi.net>
 <20130222170827.GB5126@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iEgkO1EH36X1eT6a"
Content-Disposition: inline
In-Reply-To: <20130222170827.GB5126@kroah.com>
Reply_to: William Dauchy <william@gandi.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iEgkO1EH36X1eT6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb22 09:08, Greg Kroah-Hartman wrote:
> You mean 3.4 and newer, right?
> Are you sure that 3.2 and 3.0 aren't also relevant here?

They are, but didn't test them directly.
I just applied them without trouble.

Thanks,

--=20
William

--iEgkO1EH36X1eT6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEnqEIACgkQ1I6eqOUidQGXrQCgnLRWYUtX6Myls8YUIa/iOrGX
KYcAnAzu8gk1vvWN/jRVR/Du5RiLpZFi
=hcUL
-----END PGP SIGNATURE-----

--iEgkO1EH36X1eT6a--

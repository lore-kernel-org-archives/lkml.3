Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3HBKJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:09:25 -0400
Received: from up.free-electrons.com ([94.23.35.102]:58924 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759379Ab3HBKJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:20 -0400
Date: Fri, 2 Aug 2013 12:09:16 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: mv64xxx: Document the newly introduced allwinner
 compatible
Message-ID: <20130802100916.GT2911@lukather>
References: <1374650075-26190-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cbsCxbAnPLQXdgdB"
Content-Disposition: inline
In-Reply-To: <1374650075-26190-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cbsCxbAnPLQXdgdB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfram,

On Wed, Jul 24, 2013 at 09:14:35AM +0200, Maxime Ripard wrote:
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I'm not exactly sure wether it should go through your tree or not, but
since you're the one that merged the patch that added this compatible to
the driver, could you merge it?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cbsCxbAnPLQXdgdB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+4VLAAoJEBx+YmzsjxAgDk8QAJqoFxXIasTdGPLBHJVapDn4
0icP/Cvnmgw/a5hg7s3gibv52vhgJ43KV+OY3dAWU+xKTO/4fxzz86lCWIctLABM
ahhzXRIJbxuvsCvNQYH193klIrJqs+JzvKSUzwXc2vewFq2ZcGF5f6iVUpADAhA7
XQ8agrHRgDl/q1mU9lIktQyLbp3aGfAgxwMyuQhpZFI9Hwa1UjOqmy01ld9WMpL1
Ou+EdW2psEZNMM0jkwvx75reCPEM3kRo06PP2K6mOJfwK8hxQoBJpJ0AlK5mHprA
TZsrTnUkxFsXUJe5QX9tFP5ZV788ssc5cWyr8t8o5lJ00Cjrj0AWAY/0zbE7rLe7
DnCu8Pt4fumT1R++k2AQN0pKp4weAu+6lCnf+MwavxPWGsK4NpNhR1yOy7TnRrxq
sq4dPVLXuIbfevkh6Eey50XpdwefSFhF8d4ro1zC4jmzOaVvm+7C2brcwwiTqXNI
uvuQm7RhEB9JMLh4fsZovd4rRgYEfNm0NXMABCFYLL5yWjEOQQvS2Q4NbDVHlOO4
X3JKaePzvlSAXbLVNauO5kq2OmzpsjM6pafzkhd3ez3r8EPItYDUR+GHgvPuvyyy
rvWzReAEMaX5aQVYgOGjis4Ntq0lW4Shmh8MfODm8XQs+mrL5MZzL2jG46c5xccL
Y+NWFFeZMIjHEmx54tmq
=+0Wm
-----END PGP SIGNATURE-----

--cbsCxbAnPLQXdgdB--

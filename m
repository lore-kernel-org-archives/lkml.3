Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKJOsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:48:42 -0500
Received: from sauhun.de ([89.238.76.85]:54217 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbaKJOsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:48:41 -0500
Date: Mon, 10 Nov 2014 15:49:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Danielle Costantino <danielle.costantino@gmail.com>
Cc: linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: mpc: Report correct I2C error codes on Freescale
 MPC i2c bus driver
Message-ID: <20141110144954.GC10422@katana>
References: <CAAVjN7cpGzokOntyyGVBksdvAw7rGt8zvggpCeMqr+g1yHEyzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <CAAVjN7cpGzokOntyyGVBksdvAw7rGt8zvggpCeMqr+g1yHEyzg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2014 at 12:05:44AM -0700, Danielle Costantino wrote:
> From: Danielle Costantino <danielle.costantino@gmail.com>
>=20
> This patch enforces correct I2C error returned codes from Freescale's
> MPC i2c bus driver, allowing for proper user-space/kernel error
> handling.
>=20
> Signed-off-by: Danielle Costantino <danielle.costantino@gmail.com>

Tabs converted to spaces here? Please resend properly.


--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYNCRAAoJEBQN5MwUoCm2SNYP+wTMqmAkPzgp8qvA6C/rOGST
HxIjTxaMnTRaVliJaQ8osT1vOmIbMZYqkev3LBv9LfSgoxbw+m+9JUuxR5nT0CSV
imySgri4plC0NkAZuZsSjlW8yNv3LouF7aq9ne7eeRBt9M0TNfgIjDnxgvo1Cl9q
OAO02VKpsVvMtjWETKo5bq9LfSDdehA1wQCa/aEZHkLi2d73N9ArNWCbq7LhHLGa
vq511kLTvZos6jR3a/HE/e31DfSE1tMpu6sAM97SMP7XMw2eq0rYkIiuncePB96f
IDAtAPCtOHlBPSOg3BCe7qkj/uHn4gAp3+842szslSRSFVethwu/ASitJADiwZR7
H8097ELfiJd7Ej/aTvq/6f0QU5KBq5oVYSM4CFh0b5PYgrcZImgxS6bmMCxZxBG4
65B/86CAiMJh8DNQnEh45IAVhUSUpRDG8GYlPLNZXhxxT1pChqgXNuxAHAg1pJJo
MO6i9phpv9V1Y7uOHItxdjDQqiKDZYPxcTbPnJqrDbWo+Gwwd20ltw95y5JVfsG+
Jid6VyZIficiVHL1/E2vmDqvzBt9W7pZWnItqsJvBanrxFhKUve9J7r2NnVcdrZA
+6980pqlJr03E2jOiB21TEpUKpQyeM2vH+nYh0lPzbWabQFGO0tipIZb81BjNFpU
/7y0d79tHsFFu2YgxZqh
=1hxB
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--

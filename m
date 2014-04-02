Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaDBORK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:17:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43884 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaDBORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:17:08 -0400
Date: Wed, 2 Apr 2014 09:15:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        <chiau.ee.chew@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] phy: don't return error from the stubs
Message-ID: <20140402141506.GB8504@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396441543-11744-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <1396441543-11744-1-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 02, 2014 at 03:25:43PM +0300, Heikki Krogerus wrote:
> Returning 0 from the stubs for the functions that are used
> for PHY controlling. The interface should not appear to be
> failing with every operation when the framework is not
> enabled.
>=20
> This fixes an issue in dwc3 driver, where the driver fails
> the moment first phy_*() call is made when the framework is
> not enabled.
>=20
> Reported-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Yeah, I'll ack this one because for platforms who really don't need to
SW control a PHY, we need at least *one* way of not depending on it.

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTPBtqAAoJEIaOsuA1yqRE89MP/04QwQ/hXc/PIqu2Kbza2zdK
9HwQWT/m15q4JDbW9v7p7CJRhItg9XSWAbz/E9A3aj4mR9qm5gPbYIwHHTwp4gLj
+mzY5Ec/aApABwtOfAlzhOXuF0U6qZCV2YhJZ2jpCQuUirvcs1KvYR0sW2IABB2k
capF/upKfWkwIuJN9301fuWwTOtQj+59I7UnkUPPi8oO5rOU1XgcC5sny2pn0/v2
rYxTfVe8gVK0FFoKvYEgv1uMKMAmRcHsBTWqBbyQwD+r+PAhYsmAzO6KAcwcHqWe
tyZ7VNQGcqBP0V6mn45CKGO5UvDmC9srURGCT3pNBq/n4Rua9lykeouKxs3OkZd6
Ci70JRond1jwQmGPv0PxgMaR4FRlzibwUZ0xFlt4x19XKTsRVo348DQId6tQJws+
zTEKEZgUuTPA7AFgE3x1ScqaGhkhF2qAiRED5iyb59ldYSLW9jqYAE9/xtOdMOk+
8dyZxr+vc4JjIgWQr0X1J1GAXmGx9+zPhBUOrTfEdpKFJXqSxrsMXqciJJTfFA70
P+JqJ6f8cnI49AOyJRElAjGiPJ/HA+y4ZYoLIPN6f3Ry1k4pqS3+GPFWaEz12JCr
jmypb4BbEzPfMQw/XOK9zbPU6k5ZKLIlygLyT656kSjhLmzspERJTRxROYKjvTn0
gHJfj+znTwsoDAykDmJ+
=FTxM
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--

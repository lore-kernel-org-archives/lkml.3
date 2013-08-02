Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3HBKQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:16:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34886 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3HBKQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:16:27 -0400
Date: Fri, 2 Aug 2013 11:16:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130802101602.GJ9858@sirena.org.uk>
References: <1375431557-3096-1-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUYVwCrjRUF3yxCY"
Content-Disposition: inline
In-Reply-To: <1375431557-3096-1-git-send-email-zonque@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulators: max8660: use i2c_id->driver_data rather
 than ->name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUYVwCrjRUF3yxCY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 02, 2013 at 10:19:15AM +0200, Daniel Mack wrote:
> Introduce an enum and denote the device type via struct i2c_id's
> driver_data field rather than comparing strings.

Applied, thanks.

--SUYVwCrjRUF3yxCY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+4beAAoJELSic+t+oim9pCAP/0Xe9HfJ5lOaSM2h+UtWrkz6
Vx/UpOdlbXgIYJOGhNXsjx8mZzIm/9zw2Yn18aDzQYS4clHjq+KO5vajcAJVnl8E
fm86XVp5i4T+OnpxqH9sJwuEjzDaW3ZsiTcFUFCfcXGhuVXWGZUyOM9wcbjsjdFG
WTOPfgzoPGGhrS8LQLjr5Y6Z4ePnPs+RssOH36Yg3gm0YtT9hwF9Fx7YHJ32K2U+
Uz8FWd8t9Lw+PmgvzDDPyLkQQshv6bOWZ+cK8iNmoNIubrwqbejFUfzlDxEM7Ux+
7ldfZeqBjHS2FahRbJO7vpH6OtyEf1SvxmF2pFHW4J7LS9G6QGeMFa2lRCo8mCO/
xRGYCodkPey7eVC6tIx4CMF3voM/TE3DZsIOaO6dUNb8CKEDGZusJjzeh2TsgnD7
HGptALuVavM048gLq4P4yig6qKg8ilXBj6LM7yl5an7wIRJ7zIQl8hR6BAD267yL
sOFjPL7AYGV8AvUg3Xb8XcvbA16szUV2apjLevyZ6B5LOkpxfUyUM+MpTmo/ghAj
g7n/A5QmduRi1rZTkOviwazwv/KFDBP4uM4h46wUjbzYHglLm4WF7hcvD6sLoUdZ
Vch7EA4SAmcpfuW3SjO12hR6rlaDWkyEysOjxv11IdTUycBvL0GkBqvnJW3ZeVx7
JKc32BaTe7LvNCHc78W1
=wxpX
-----END PGP SIGNATURE-----

--SUYVwCrjRUF3yxCY--

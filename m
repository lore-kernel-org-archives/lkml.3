Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3KZJGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:06:51 -0500
Received: from sauhun.de ([89.238.76.85]:47118 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3KZJGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:06:44 -0500
Date: Tue, 26 Nov 2013 10:06:39 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
Message-ID: <20131126090639.GA2568@katana>
References: <1385447520-3306-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <1385447520-3306-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 07:32:00AM +0100, Mike Looijmans wrote:
> Leaving the mux enabled causes needless I2C traffic on the downstream
> bus. De-selecting after every request causes excess I2C traffic and
> switching.
>=20
> This patch implements a hybrid solution: After 200ms of inactivity,
> the mux is disabled.
>=20
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

You still haven't answered my initial question. Also, please don't
resend without saying what changed since the last version.


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlGSeAAoJEBQN5MwUoCm2+FsP/Ay72uYokHZl9LlYzQsua0fi
amxhg0hHx9aVV0JnK3mURp+T9725y/zYOXkijPiT/rMEvDpd5jYUPsWvdB/gbSL9
CyGyeYUr6G0gUFE/pjP7VFpEMfDo/6lsDWSWFc0grsiN8nJS1pMqGxp75J5i7d3U
53k4brLxkDKgq2LzeIJ4YaJ+6zlkC2Cuk6sC8LDAtABCjERPfxn8WZ5V5/Uq1Avh
7SDpKyDkoMygJF9hzHcWg5qa4pfRmIyqWIBqdmtZIpCQrExF1gSvqCZw1Bm4Vmab
vBPkD4tF5aTiiymj71mXQFFTCJqAP5pYgIAV2n8Hp1mSj04+vG8ruBbQtNqsKocJ
/3wSPQrRDP1diuPbf2RPSroMXDb/fUQ86cd0XMynJO7qeJIpwKwGeEkJ0bqY8A0h
91ytsulEhodkOyhNhKEdMJeoU7SUhVn6llN0n8xAVMCRRrO2eEIUmdu1TMErRPlI
fy+u05AS4IH8R+aBEWG8kUWEvx3YHDijtlB6qEvFVEMbR/9qrJF0jWc8y9HVR2OF
kJG2f9vdtfyDfqcY/ks+H7RVa79MdU5lEYJ69QQyyYVoxNZjUGO9mGWwv02n641T
1qB4Iw9Rzws2ub5XdVFSkGrU0GXyk+sCNBy95dw4x4koOArCQyVA8MFdpEB4N7LG
CC+yzaP4AyuTJoNkTgqT
=pQ6r
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

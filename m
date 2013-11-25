Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab3KYO6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:58:00 -0500
Received: from sauhun.de ([89.238.76.85]:45642 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab3KYO56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:57:58 -0500
Date: Mon, 25 Nov 2013 15:57:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
Message-ID: <20131125145754.GE2705@katana>
References: <1385387037-3710-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <1385387037-3710-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 25, 2013 at 02:43:57PM +0100, Mike Looijmans wrote:

> Leaving the mux enabled causes needless I2C traffic on the downstream
> bus.

This is a bus. Why is this bad?


--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk2VyAAoJEBQN5MwUoCm2LQwQAJKIvASVHra4H7MV+lP5nD3q
pOuj14j64nDFyYVT2LLgfuJP7KHk2rMYu+yyAOlr0b42W/faRJ8BHSx9j7G/w/lc
W2yPt1/olJvS0StBRJ5U7370zBPvWTjJmjwHLCFB8G+wkDAbsliJ8ttvBHERJs/D
NVZ8vKsdyWa3IZivf5O8yPtM3p/vwjjDoLL0QdoqQfL/3CZgcMU12kS4i5HoHB0h
31jBu0Xf6rqSqIC9JHsXMU7sMAP2B9n/g1M1ypw0bFyBiun2fdDa0/lmPrTIodHr
Em0fbkRpuWsFa5aUviH6yNTmzffaP+vxkue1nPvqVR0fcX+Kf2+m4nTzeu418kzL
OCsAIHDYmnTvSajLE/yoEEIbEUfDMcPUquwfG62foMOkVRC/k2QYo0zZZPhl2b0H
C2Tz0+906muFu/JjUq4FJhmKUT67nAeCVD4Rm8Zzuesdw5N10m0M8Mgy0RFDLWVl
Ef5sal/PcNLc6Uf30nlhX1A9JMap7aVux0a7yMupIisSPBTlaZYRoQhX8V5BODq+
3RlaaywwYultzXM6R9rmV/Drkdqx/BUmKxKQ8SYE0+2IOhYa6pdBSILr8IuJ5zwh
2M8x6hTqlbKLnxP7lFPHIVNLEco0/aaZX9LPyun90dIvV5k/2ddu9lih5DRJV0dq
d6KJUYKCtqGi90uURgDa
=Tapa
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--

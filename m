Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaF0LZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:25:13 -0400
Received: from sauhun.de ([89.238.76.85]:51640 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbaF0LZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:25:11 -0400
Date: Fri, 27 Jun 2014 13:25:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christoph Jaeger <christophjaeger@linux.com>
Cc: jdelvare@suse.de, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-taos-evm: Use module_serio_driver()
Message-ID: <20140627112505.GE2641@katana>
References: <1402689144-20259-1-git-send-email-christophjaeger@linux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47eKBCiAZYFK5l32"
Content-Disposition: inline
In-Reply-To: <1402689144-20259-1-git-send-email-christophjaeger@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2014 at 09:52:24PM +0200, Christoph Jaeger wrote:
> Get rid of some boilerplate code by using module_serio_driver().
>=20
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>

Applied to for-next, thanks!


--47eKBCiAZYFK5l32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrVSRAAoJEBQN5MwUoCm25ucQALAbh/7ybr46ZqfdORPHHqCU
ofGc0SfGP2ij24F6Bc3voFDBksoyqNe7cVzoa6tgT70Xsp7ACHcuXnSfpHFxkRyy
6g5zWumeyp2p64WGkPwZ3uXLbxU75fc2USKjFzY24ogsbHjtM9Dj4/um6yV+QAJI
gabcMQKPhydkdXCj4//1e4U+Cb2JaEhinRVCBq5mviXX/NFeICEJ8uG4UhtlAMEj
29rLe2/7kc7q02Ny1YlUvK3+lVjq1QEYZNfb3AwSU6nN2HqkLUJb5tvZuxkdSUcC
owkPPsCoiSSbwYF/ji+baqbPvcpMEoOXBedWIw7On00BXXA1aqWA/pIcPLZqD3nh
vCeDfOdbvbZeEfw0b/jJeoTAP+KVGVtDGgUXxwOWrXNQy9aaiF9lk2pWdIHOLLOu
I575LRHkoYAudrfen3ZhiT41GDVjq4Qv73MSYlINU2AuBvyml6F+AccKmt/9k+ga
6B0N+VQcCS+EsYsKtAz+yqgA8nBnfUyjfeOr1P+r0Q0nW1U+krAwmmeVKvA5ubNL
i5E42ziJX4no5D4ReZ0jyBxCzk9PtOAt7IYDbjqkysiDw9Zmqgbd2yfTHCC4eBkw
DNcRJHjRg9tPS1DECyarMCwxX7yJq3tMCu3wdwdXT2c+NLdy73HJQMck5pTR7SFE
CtdLDpnUJwTvi+LXFONy
=VuRN
-----END PGP SIGNATURE-----

--47eKBCiAZYFK5l32--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbbABWtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:49:18 -0500
Received: from smtp1-out.insa-rennes.fr ([193.52.94.24]:15118 "EHLO
	smtp1-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbbABWtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:49:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAPgfp1QKBQEl/2dsb2JhbABcg1hYxjWFcQKBHQEBAQEBfYQNAQQBeAEQCw4TFg8JAwIBAgFFBg0BBQIBAYggFb5AAQEBAQEBAQMBAQEBAQEBG48VEQFQB4QpBY9ggSdNiziLSgKEEW6BDIE3AQEB
Message-ID: <54A7204B.5020603@supelec.fr>
Date: Fri, 02 Jan 2015 23:48:43 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Epler <jepler@unpythonic.net>
CC: Richard Cochran <richardcochran@gmail.com>,
        linux-man <linux-man@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] adjtimex: PPM scaling is by 2^-16
References: <54A2DEAD.2050708@supelec.fr> <20150102024118.GA8293@unpythonic.net> <20150102062920.GB4221@localhost.localdomain> <54A6C9B5.4050904@supelec.fr> <20150102211519.GA55815@unpythonic.net>
In-Reply-To: <20150102211519.GA55815@unpythonic.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9nbil89coSbCvO5K6A8B26kx9NV0MJosQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9nbil89coSbCvO5K6A8B26kx9NV0MJosQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Le 02/01/2015 22:15, Jeff Epler a =E9crit :
> However, the patch got line-wrapped again (I fixed it manually above).
> With line-wrapped fix, consider it
>=20
> Reviewed-by: Jeff Epler <jepler@unpythonic.net>

Sorry, I'm giving up on 'normal' email clients to send patchs. 'git
format-patch' and 'mutt' will do.

>=20
> hm, as a separate issue, "ppm" seems to typically be written in
> lowercase.  see e.g., http://en.wikipedia.org/wiki/Parts-per_notation
>=20

That's right. I'll send the coresponding fix in another patch.

Thanks

Laurent



--9nbil89coSbCvO5K6A8B26kx9NV0MJosQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlSnIFsACgkQRTidSplJch7IkwD+JJaq+5FkHFLJ9di288HMkhoe
/sB4eRJD7un9Ya2NZhoBALd8UsZkZ97HkDPZ4Y1MsgzcFJwqWm57XrwLI4QToER/
=ISbo
-----END PGP SIGNATURE-----

--9nbil89coSbCvO5K6A8B26kx9NV0MJosQ--

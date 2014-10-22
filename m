Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaJVVeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:34:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:45578 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbaJVVeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:34:02 -0400
Date: Wed, 22 Oct 2014 23:33:57 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH v2 26/47] power/reset: msm-poweroff: Register with kernel
 poweroff handler
Message-ID: <20141022213357.GE28840@earth.universe>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-27-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
Content-Disposition: inline
In-Reply-To: <1413864783-3271-27-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 09:12:42PM -0700, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Select fallback priority since the code does not really poweroff
> the system but resets it instead.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUSCLFAAoJENju1/PIO/qaIJwP/2YaQcShu84vwkr1hjY77pAy
NpT03XD0yJs6atRYhqkx+wcwuox7yGQTTC87HkLRDV9fPbVHTHtVcNastiAwiLh9
CoWQhixQlmADRG+kRpkfmTxtqIx68ff2ooNqePSPrqh34sMAfrex0j1mcvPnpF8r
/9E22ZEHzyY+qCQSMTHSYiEJjkONGntkmKHcnQZsclARYoXJFduPbsVh0bJxmzDQ
21vHFRiXp2RvsT6o0uf37kd/tpe4eC3os8l3tl29ch8oFHHc8FgzqhTDYSJv+yvW
cDi7pgcGl8KK1zh3n4nKOYJKeuPvW8nQXsVN9VrXUSjNiFk5vhN8IJqwwFi6G0DQ
v9DGiqdO/h0wvf8AFJgu2H4Bvrle+AbcCMfSNdMrqnLjnX6iv7oO2r0T5L7x3ilr
/lhk0fPDInAI6Ni/RM5M5NdGVRTSl7/JYJbXN5QStKZmRCYnmhRbdvrsSJ9/QOdt
izMRNTAsDg00eeOC9Za3Z9GFcLCiB9AeiMvX0Fso6oPkqUI1PNtTtEQz+NJ1Trsv
YOL5wMLs3bg78CJ6WqWrxvFdXkB4VOMis24xcfeWgtA4hgmnCooTKTcMh1NB0Gs8
HC1PBjvD5vLEBjtZXhA+2WHUEess1wXkaW3s8KzR4C8xk2YRBjQQY/Btw/67qfv5
KLBtNWoiHKvIY60eLPEA
=J2nc
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--

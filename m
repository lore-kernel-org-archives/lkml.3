Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822Ab3LHTJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 14:09:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43541 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3LHTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 14:08:52 -0500
Date: Sun, 8 Dec 2013 13:07:39 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/15] mfd: menelaus: Drop __exit section annotation
Message-ID: <20131208190739.GA18977@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
 <20131203095136.GF11828@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20131203095136.GF11828@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 09:51:36AM +0000, Lee Jones wrote:
> The code looks mostly fine, but the implementation of the commit logs
> seems lazy. Please submit a v3 using coherent sentences with full
> explanations and correct punctuation.

example ?

--=20
balbi

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpMN7AAoJEIaOsuA1yqRE7dEQAKVbmUQ5fRPtXYvD7JgugARs
UuPuBUZoz7d5y+E/i4aDuzkEzWZpA4BSNq9d1UKkGwPKidWS+g5PSlyWJVy2QXq2
iolo4+Yc43jHLPsXi1qLo2V0ISbBgSVr9U6uUVymcCKs/ING93cu44EIa+xetwFI
0fNxSTIZi5y+0bPTOEJ1NJ5HqlGxt8qy4EAiLAP5qCp9OJydLSE/MqSDHclm/wFq
aV20GEndEt+4c/as/FLp0ubXuxvDN0Lqs+dd2qm/EFD5H62kDdXJVNhM9A5zAzfP
tRYpd6hZ7qMtXbXqNxX/wUxWrU5F9tqJz+uQxto26IzPCXOhbgoUQUhS9qqmXXip
bBVdA4RblSb8YRbrznasaRlitXLHplFubtYRnyW7+wzmMOjX9Fb37wUhDXHS8eF1
f/Kw+IZustIb0rwxul8nmkmv7cTAPZQO89/LSalN5coRxmA5+ninpHgSFhjVl8Ln
XQYMPKMGjcIjDqS60vI4XoeU+pFHHICu9gTWrtJXPwn/NVzu9jws9lVZl80G7bJ5
Bq8z6pjEulwzLtf9rCYhsbjkQ8OMrSQoPOQQ5hDpgAYmC6h2U0Uu9iVFA/OvHPaw
4xKMFQHNnzDSCxl0SLze66ZQZBoeA9n5dthWDo6WVbECbrNDpT9JBcMhE2/Dz2oh
FSTqJkw6HKQsHJSMqusc
=bcs4
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--

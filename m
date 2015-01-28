Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbbA2Gen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:34:43 -0500
Received: from sauhun.de ([89.238.76.85]:37899 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbbA2Gem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:34:42 -0500
Date: Wed, 28 Jan 2015 07:59:29 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        david.e.box@linux.intel.com, linux-i2c@vger.kernel.org
Subject: Re: randconfig build error with next-20150127, in
 drivers/i2c/busses/i2c-designware-baytrail.c
Message-ID: <20150128065929.GA1086@katana>
References: <CA+r1ZhisCd7+LJ0gm-NLPJ+UE-FEuEWFQqDqcy7KPp2tD_bveA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <CA+r1ZhisCd7+LJ0gm-NLPJ+UE-FEuEWFQqDqcy7KPp2tD_bveA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 04:41:44PM -0700, Jim Davis wrote:
> Building with the attached random configuration file,

A proper Kconfig dependency fix has already been added and is in
linux-next as of today.


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUyIjRAAoJEBQN5MwUoCm2QlYP/0zO854F6omGBspWgmMoMN4d
6lZmyiBqOxwhLlSIrcDJqbWVvxVaGXcMhJL2OppeH0y7AZQrXHFtTWWLPqPDS4qG
JdRHhQj7DaoA28rZ1/09TRcdK9UHGPJvA93Qy0gxOaAnpHRnaKR6HZXIRtvkY1PS
0gDSixw1Ib5dwgtJFNzSRcc00RdmpuXefvtFTCJ/0ogvtovDXBSKQQ5jlEyq2GZj
KQDXVmZiKvOseSKvPnNmjBmCGxaId1QchrAnpWTnUq3K/5mmBa+mF0gQLyFQBrKX
64Y724mgW+4grWyzlbuM7y64ZWh8HOUQLeppcV6/x/ukqpscZcdFvI0CWhDhurA0
D8SAjsMNCiBn4ui2Her72NsFg+Iwi10lVj+ceseXBZ5aBs9gZNuHG4jbaOdtU2WQ
0OI7iV/+ikHy5cjiAb0yQKRrSfgfZCns9SOKwMHWDaFKzj+xBdNWUGZh+rvFt+Au
ns2kvAgNZubbzxhpWW/AA7zAauCpjrvDgo/8K8Ext3N9/VG9Zaet/jpg9CNM7N82
bvjqWlpV3BIe8dO9YB8pT4oYJxRYggxA7cyOas5/VmNwFmW3vI3L0au/oUAhXwQc
s28cGzjPQ61hHPOBqYQ4ipz1afQ9SFhZiYJjxHvakiwEKTnBmbkPHnurdmumPSJT
U94XVQ+DUoLiwvADP8WM
=lF3S
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--

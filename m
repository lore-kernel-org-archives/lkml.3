Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3AZKDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:03:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60194 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab3AZKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:03:35 -0500
Date: Sat, 26 Jan 2013 18:03:28 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] regmap: avoid undefined return from
 regmap_read_debugfs
Message-ID: <20130126100326.GK30594@opensource.wolfsonmicro.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-12-git-send-email-arnd@arndb.de>
 <20130126044219.GA10580@opensource.wolfsonmicro.com>
 <201301260917.28028.arnd@arndb.de>
 <20130126094855.GI30594@opensource.wolfsonmicro.com>
 <20130126095916.GB23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E6lVPAHcXg6biC3t"
Content-Disposition: inline
In-Reply-To: <20130126095916.GB23505@n2100.arm.linux.org.uk>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E6lVPAHcXg6biC3t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 26, 2013 at 09:59:16AM +0000, Russell King - ARM Linux wrote:

> Why not code the function in a way that avoids the problem altogether?

That'd do the trick too; feel free to submit a patch...

--E6lVPAHcXg6biC3t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA6noAAoJELSic+t+oim9ABMQAIQ20ecHyej6TxKsx75pp0LO
uZHIeIjZWATrW0l3WaKpBR+SsMJE+mP9tlHgiTwX61bECdt9yNzBKY4NK9CbdCsY
RjA4aj5MKlIFpg6oFDi1LkTgJx/SAOR961A/VjIdQfaWDj79Zl0Pua4NPnW7wYHI
zhcvAfI01PRUk1IIprPSkeDpCOauQvpF9lG2ZkCOSXfWnBuafVqJrTNy+vZ7T9HS
V3qLuaq+d+sy9Srap06oWfXLzk+gWVUzJZ0Sl4UgVDzKEWHsTbgC1ukLfCmC6SCD
+bycA5EWRAb8RqEXriP6EZGMHLcgSwZMq7E0fnlqgawdjUW03JVjP6mf+pm9Bs6o
JgPtC8GigKVtXf034/ZLKzPmZ2/6gy4RoVRDQOwEGsSdMB3VWgllQPVcRADCFEL5
xaba3bErSbXWZe/HAdkm5KvMcO5NWPw8oXSwUU78rbuMbJ8iEZVfnPKKzs6uOsGx
7+BZc67INNhmnWsGqMuOKzHddwXZdtgtMz8T5ZiFL/MgHxpLLDPko8v7Hb/IJex9
GzCtor6O8NX8xvPacg+4VSYglCXCZn7my3SNxrtLTG0B03WH2bX+9Ywb2ve7Gpcq
rOdMsyJ4ekm3J+fJZKmBdg8VG5qjndCp0D3bta3U0ZKy5OElbr0B6JuH4bKTJJi6
pS9qr65ryEU5ByEqt10M
=0vZQ
-----END PGP SIGNATURE-----

--E6lVPAHcXg6biC3t--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaHOLDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:03:36 -0400
Received: from sauhun.de ([89.238.76.85]:51702 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaHOLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:03:35 -0400
Date: Fri, 15 Aug 2014 06:03:23 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: mika.westerberg@linux.intel.com, torvalds@linux-foundation.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] I2C: Rework kernel config I2C_ACPI
Message-ID: <20140815110323.GA2860@katana>
References: <20140814093743.GB2824@katana>
 <1408081139-6292-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <1408081139-6292-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 01:38:59PM +0800, Lan Tianyu wrote:
> Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
> config) adds a new kernel config I2C_ACPI and make I2C core built in
> when the config is selected. This is wrong because distributions
> etc generally compile I2C as a module and the commit broken that.
> This patch is to rename I2C_ACPI to ACPI_I2C_OPREGION. New config
> only controls ACPI I2C operation region code and depends on I2C=3Dy.
>=20
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

It looks good. What tests did you perform?

Thanks,

   Wolfram

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7ej7AAoJEBQN5MwUoCm2qmIP/itdQe3hh1Yc/8dD7dTF30L7
LHDSUUCgNmunqfRDNRcpeixSyK3097XCYaftnZPkRVEsUV3p0CS5Q+w/yBB/mDJ3
/v8PUo7e5Hmeoe7Mir1CcOvQybR6in1snR5l5qjJDSnNXApKLbR1DrdG2fTU6z9G
f34q27U1xewpFXu50kwg2TIXBmp0tYet7FCebDYeh4u/T93sTzcFvDvR84M2gJdA
U/tHa9PG6NfMMXltaX4ftf2rpla15Z5NoLKxM9zuaLPapH5jXcYh9+8WmOjzj+Ib
qrYG4F7W0wtZtXzREr8wd4aulWYHoRzTPEaRZ7lk5Y7uILFMapZ0gkQXHubhjSkZ
YLqKxsEnFeo1uGKapyEeiFRbLs9ogBEUpHJWGuhXzyhY8VZbT3fuShFR19lFRevZ
8z+NT7JbNx8n5BEkkW1sf9lSKdPxSxPLot3s+IMzfGCgI8DMxyAr6dtglKvwcQbw
o7N5OKnIBUCpIuH37l9N4AuV/KXXMuciJhvwggp8NdUZHn14n0ROzNrAF0ntM2se
fOQhJsh7Fpn6iphlle6ewuvZ45hHJ/Bu5HPH3XqVWkAoPkwjoRvmyuJ58da5z91J
Up7BpcdTfVhDz/ajBujBXa+0fQsPbREIIhXBgtNdeY7lAiUgtGpEK3BIcUB1WrpP
uA8yuHwkc8dFeoCINFpy
=nzCg
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--

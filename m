Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3JEKbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 06:31:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46429 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JEKbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 06:31:44 -0400
Date: Sat, 5 Oct 2013 11:31:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        rjw@rjwysocki.net, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Kevin Hilman <khilman@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org
Message-ID: <20131005103106.GX27287@sirena.org.uk>
References: <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
 <1380632982-10709-1-git-send-email-mika.westerberg@linux.intel.com>
 <20131005080901.GQ28875@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TbvQLmyOl28t66Jz"
Content-Disposition: inline
In-Reply-To: <20131005080901.GQ28875@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] i2c: enable runtime PM for I2C adapter devices
 enumerated from ACPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TbvQLmyOl28t66Jz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 05, 2013 at 11:09:01AM +0300, Mika Westerberg wrote:

> It looks like Windows actually powers the I2C controller off independently
> of the I2C client power state. We should probably do the same in Linux even
> though it is not following what the ACPI spec says (but makes sense with
> serial buses like I2C and SPI).

Sounds like it's probably worth going to the effort of getting the spec
amended...

--TbvQLmyOl28t66Jz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJST+pnAAoJELSic+t+oim9w9UP/RVUc3CNBP4r86nPFZL1CuW0
PQQp7vxoQM6jJJvaNRMiMMhgI43FKj2XdhwuLiQpDuIAy0kU2j8LorgYi3/JgWgy
Zr7uzbQY2s/3KolUd1TySw2Gxe3CNdDuN8fytTYBKW+U6l6vcAjw5s+xUSyXveXB
SY2diiAtXpbXFADR+JhjvIHviDGSsQ0NyFYDismzWTiwLA5oRaT81/hVvkNnrxxD
/glj2ZYzrVxL6cASA94b8JlZfOCl8WSAIvX42V3VbATc62lMUqTQosfSXj0wGBDF
9KbbvRNfQr9ilKCoBhxX0hPXH6mmqvbX2yDkVxEKc9DitAhBtZ8Ba6zgBc2A7iWO
v7i98Dxny8t/VWF18q5rjs/CZG52JC7zmxpwJ9r1YNSTHVRkllfHx4GZMT6JQNao
HjdCg79PgUPTS7EdaOb+i6ircogOSjOxEBnMpmorvRlvKpOzp3AMe/cicWPc9Viz
oJV9eN0sLrLony07/7v/3cOqNGrSiGxPVdnima1Yeghql4l8GjsFe3UFHZk1IUSi
6vhLsSofftqFeKLOmY32ADhj1CjzhS8xy2mr0NPI+L5D6JmLeIuBsIdlt5YhKdbm
6HCq+/zTW10fWkaUpFoPD87Ss4qRPXLea0ujBZsXytEmnNsRT5JI9uJgJZQa7nXt
ZYKoX/zcDbJmNwEAj5dv
=EfJ0
-----END PGP SIGNATURE-----

--TbvQLmyOl28t66Jz--

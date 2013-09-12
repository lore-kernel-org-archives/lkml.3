Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3ILLEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:04:41 -0400
Received: from sauhun.de ([89.238.76.85]:37086 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3ILLEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:04:40 -0400
Date: Thu, 12 Sep 2013 13:04:28 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, linux-i2c@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 8/9] spi: prepare runtime PM support for SPI devices
Message-ID: <20130912110322.GB3367@katana>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130912093145.GA29403@sirena.org.uk>
 <20130912094302.GM7393@intel.com>
 <14222641.vVF4lKBqCB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <14222641.vVF4lKBqCB@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 01:04:55PM +0200, Rafael J. Wysocki wrote:
> On Thursday, September 12, 2013 12:43:02 PM Mika Westerberg wrote:
> > On Thu, Sep 12, 2013 at 10:31:45AM +0100, Mark Brown wrote:
> > > On Thu, Sep 12, 2013 at 12:27:43PM +0300, Mika Westerberg wrote:
> > > > On Wed, Sep 11, 2013 at 04:51:20PM +0100, Mark Brown wrote:
> > >=20
> > > > > I would be able to have this and the other patch in the SPI tree =
in case
> > > > > it overlaps with other work - I'm not sure what the plan will be =
for
> > > > > merging this stuff but if there were a branch which I could merge=
 into
> > > > > the SPI tree that'd be good.
> > >=20
> > > > I think these two can go via your SPI tree as they shouldn't have
> > > > dependencies to the I2C tree.
> > >=20
> > > There's all the driver changes though - it seems best to push the who=
le
> > > series through one branch so there's fewer bisection problems.
> >=20
> > Ah, right. Then I suppose the right tree would be the I2C tree (as majo=
rity
> > of the patches are I2C related)?
> >=20
> > Wolfram, are you OK with this?
>=20
> Alternatively, I can apply them too if everyone is OK with that.
>=20
> They are PM+ACPI changes after all ...

I'd like to give at least an ACK. But I need to find some time for that.
Is it urgent? Looks like 3.13 material to me...


--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSMZ+8AAoJEBQN5MwUoCm2ZqYQAKHielc0q92g+LBhYgF/srww
Wy6QzUl3I9duFiNPY3wPEPN75OxoRjA3gqe0OoHDDecHW9S7sb6+rsdEjsonC5W3
HZtkZfDg9qTfahOytnlA6/ebDgUC2AzUcDmRx5uBIjayiRK9bfrDU65IUKhmP+2z
akFW/yJEYevHrbnDQBUsBa74hL9JxzyIKathh7tpX17rA/fd/xCyfvaiX6ld3gDK
pXxCCjIBsjX7xJO4UdWwFaBDdmVts7YPakHXoxwCiFcvSA8iPqHJIS47404QGf6m
phFtLdZVAoV/0dAxEy7hJlPDPe7NaqZmdt3gaadrK3Uj03PE/tA+o+ZN/umYYKlA
w15KDDxWhbxAJqZP1xLtzUUZ5+Hl+AL2AWIaualtoBa28ftBOtfPI+2h/Fcoej0c
AWiRHScZAvtD+T1f0YKBTsLbdWLt4sEaV1jqNLRAISQdDoYKGkfRwoYVN0jeRuBj
fF/DoagocmLSdrlOSKbB72st2hUKL/uejcNJojNIguUXZXAnr3CF0oYNwj/GTOPJ
/IVSkArGlJVdzYU57jBqCdNv9QbL2bKxCeFyVvjVwsQryak2TJ/XAyAJfIqMer9O
6vbDwTnOih9Dhkv+kzglLWQXY66DwDIDnhq34dwwqr6vnmQwxLuiP+FECTfMeKL1
SRZLnS/OvrKVsThtIDi4
=AQau
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--

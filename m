Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab3AZFMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 00:12:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab3AZFMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 00:12:17 -0500
Date: Sat, 26 Jan 2013 13:12:08 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "tony@atomide.com" <tony@atomide.com>, "hs@denx.de" <hs@denx.de>,
        "Girdwood, Liam" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/6] ARM: regulator: add tps6507x device tree data
Message-ID: <20130126051206.GE10580@opensource.wolfsonmicro.com>
References: <1359024920-32190-1-git-send-email-manishv.b@ti.com>
 <1359024920-32190-6-git-send-email-manishv.b@ti.com>
 <20130124120050.GP4955@opensource.wolfsonmicro.com>
 <A4887BF146CD57468F700B415D2F4701581621@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6e7ZaeXHKrTJCxdu"
Content-Disposition: inline
In-Reply-To: <A4887BF146CD57468F700B415D2F4701581621@DBDE01.ent.ti.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 06:29:49AM +0000, Vishwanathrao Badarkhe, Manish wrote:
> On Thu, Jan 24, 2013 at 17:30:51, Mark Brown wrote:

> I too doubt that whether it should be in architecture specific folder,

> My code is in reference to below patch:
> arm/dts: regulator: Add tps65910 device tree data(d5d08e2e1672da627d7c9d34a9dc1089c653e23a)

> Could you please suggest me if it can be moved somewhere else?

We should have somewhere to put this sort of generic stuff, yes.  Not
sure where, possibly under drivers/of or some non-drivers part of the
tree.

--6e7ZaeXHKrTJCxdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA2UjAAoJELSic+t+oim9o/gP/1BPLvsiR63xW9H97PpzypHs
7UrZPlMwP5rysc6GRf+/JJHwl2VFfzReIGcej5MGZ11NVozDj4lbVttSau7m4ry8
VWU41uhe4hIoIeJu+m/AnC0iiVo2iR8+T48VPDZWv8RxeX8EATWKxm3rZBbz0L//
zDBHrzwjlHcMLgkNUuA3AhYiZUcRmu5CwnB8CcSbiPKdiNFSGpwaLaeA+IDkm1Et
PfT54TgC6umrwPPEmwo1aaresvqPOhMTer0QS2belSma6FQwWXXly+tUy6HjVZMs
aobUgmHFIKmCZNj4gwCRUVNaocZAnfJ/RSHWII3/y4PJHn9u7/UjZvrDbR4n+jxi
vMBR/Ak2LryBsZAV18r6Di84ojk2Q/8ZJqCA+1PKthb6nXnNB2SrC+bHbwowrVvK
415NNFwALR8HxO26yfW5P3qfMzPQOQmABMvtllSKkyR6dQAQjNqJUgvc7/PmkQED
yBXWzIzIKJZDQ0zrAa5bgukrVgicfUlDbSuOxUBrVD7N7rjSgdvEyNswfLKtg3mG
wI9jJmhLGJFO5KKZolGXCwgl2R372b7Cx2u0szJgUxe1LQCwOuAHlPtr8p2s0zcJ
qquWs0jwrkEafwuxwP+SpXHPEacODd/jp91a5m2AKrSc28tQSK/eJ4VAjWBfvtPj
RBpd56ge/PUUIi1DqhZi
=R9iq
-----END PGP SIGNATURE-----

--6e7ZaeXHKrTJCxdu--

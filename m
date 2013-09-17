Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3IQKtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:49:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48351 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3IQKtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:49:01 -0400
Date: Tue, 17 Sep 2013 11:48:52 +0100
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
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
Message-ID: <20130917104852.GN21013@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1861747.RtS0ZLgUUN@vostro.rjw.lan>
 <20130916233111.GB21013@sirena.org.uk>
 <1820315.QOOAzSjac3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOzekVbrLdOLv44p"
Content-Disposition: inline
In-Reply-To: <1820315.QOOAzSjac3@vostro.rjw.lan>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GOzekVbrLdOLv44p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 17, 2013 at 03:25:25AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 17, 2013 12:31:11 AM Mark Brown wrote:

> > It shouldn't even need to do that, it should just be able to rely on the
> > controller to power itself up when asked to do work.   This is how the
> > existing implementations are done - the controller power management is
> > totally transparent to the slave.

> If both the I2C client and I2C controller have corresponding objects in the
> ACPI namespace and the client's object is a child of the controller's object,
> then in order to power up the client we need to power up the controller even
> if no transactions are going to be carried out.  That's what the spec simply
> requires us to do in that case.

Like I said I think this should be handled by the power domains (or
otherwise in the ACPI specific code) - we shouldn't be needing to modify
individual drivers to work around thoughtlessness in the ACPI spec.

--GOzekVbrLdOLv44p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSODORAAoJELSic+t+oim90iEP/jU3tnrrfTERoFK9K9fLZegB
LjrFc+cOXOE7/J+FOckwqDiSV/xgmyvP59+XTdI/62Cx0+oc9XeAz5Y7k7DaIHws
bHGcen9K9SjQPlajRodHZR1VE7PB6Wp4yfm/wMInvl0k8gC6M0NUuz22VKP2UQVk
UsUT6K/Dx7eA2OtAKCId70rwQwUVhDW4UGwlSSMcwAY/+k0X1U2aB5C2OXZXH5Qs
xMYHJa+6eJ3Gsgf+uSL02+RiPbYy2MXgwTRTI874Fh54yy6RxFc8SyuMveBfCxwI
Nq0KuDdZ52KOIhWrM9orPEQXXNIjtnboH9zNlOQAqDeWOZ94nDYLyvQk5QHeNoUs
q2Db3eC7kQ109u1CkQOB294BxyAl8EHKYKV3BoQTy0YS39ZTh75F8BL6t3Dscc0I
UjcKH9hrIk2eLgGsaAwePbrrTTcqybQrNT9FCiSTJHeuzN/9/APEZ2nisC3oaeaz
gDX59vyoT38AhrLcvlYQr2uh0ZwbYFsfmt1P4KwncLzYsSQP07zJS9riL5983gg6
8EL0WAv4mHjW4bvyEIMQZfATfL20ydi0fnfbtH+AYQK7/58GEnHWkc/Wtthr2vLt
Fwhdmjh3HiZIGs7Y9eKsHCWRMPtoDaoTBO3H3qoPGU+qF0EM+966g/7e9YYdGFPo
996UUDK4oT2TID4tAOLS
=UP9s
-----END PGP SIGNATURE-----

--GOzekVbrLdOLv44p--

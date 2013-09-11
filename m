Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3IKPvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:51:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39607 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3IKPvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:51:48 -0400
Date: Wed, 11 Sep 2013 16:51:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
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
Message-ID: <20130911155145.GX29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-10-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/gh+DQSWM7aKd1G"
Content-Disposition: inline
In-Reply-To: <1378913560-2752-10-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 9/9] spi: attach/detach SPI device to the ACPI power
 domain
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/gh+DQSWM7aKd1G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2013 at 06:32:40PM +0300, Mika Westerberg wrote:
> If the SPI device is enumerated from ACPI namespace (it has an ACPI handle)
> it might have ACPI methods that needs to be called in order to transition
> the device to different power states (such as _PSx).

Acked-by: Mark Brown <broonie@linaro.org>

--s/gh+DQSWM7aKd1G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMJGOAAoJELSic+t+oim9ewgP/1c8LiaX13HrcCa3z1LjuLoH
6FfBwqCFiHw8B0VhOsv7XRUdXiG1mwbBCmi0td1sbebx4HvAbJMvHLmZE7SPkfaq
bQtUJ56CFpxMIPWMCvctY0MudYugzPCq1ZUoBZDpE5/0XaM1yeEP2ug+ljCzHG5Q
NTCfddYQfZutEdwVB8IwZSFvGuVB02A4hKUHmEDPEChiVYvP9EXYlkGLnZzjwwaL
ao2iigcv5p6q/1hAA1Xa7Pz/Q4sb6HbdJ8ScXRD60D6CAfi0Y0yb5/8nWeOcX8gO
D0u4PgDEyJgv6P30nNNNDvSm5vavGju1Fz63slet2svR0EyeFE7ciDRpJjHSZTSM
JXCNfLgOtK+QVhjo2tobH1OQTtL3tT3PekKQ9uqSC8I8G3gOocTkVxfKplpeZWeT
te++qWUEoxEJGn1cjCb/7ODP30LbDstMwxAZ4ZPWkSQeVVunRtGms/ZKohPCsiUI
L4jrCnwcC4oXvHgrlDkwes+5gOZxl+cz4CC7l2wpb+uqQsLOp5tWZ0F/NVOAsVmq
ChnImiz3iYcm7iSFu1lflsoksXmkFxKBgk6jqWX4ansID3TlHpvVAV6DuJxQJKwv
jCMoPK8l2MGBgrKRLrss2YXS3Ncy6CBv2MqT5E+9CRGwc4QDd2ez8NhqKQr8QFhr
2aA3f+/7lR7DBQf9wwX+
=DcE2
-----END PGP SIGNATURE-----

--s/gh+DQSWM7aKd1G--

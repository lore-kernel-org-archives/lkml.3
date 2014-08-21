Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaHUUjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:39:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:56556 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaHUUjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:39:12 -0400
Date: Thu, 21 Aug 2014 22:39:04 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/11] power/restart: Call machine_restart instead of
 arm_pm_restart
Message-ID: <20140821203904.GA26620@earth.universe>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
 <1408495538-27480-3-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1408495538-27480-3-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 19, 2014 at 05:45:29PM -0700, Guenter Roeck wrote:
> machine_restart is supported on non-ARM platforms, and and ultimately cal=
ls
> arm_pm_restart, so dont call arm_pm_restart directly but use the more
> generic function.
>=20
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Sebastian Reichel <sre@kernel.org>

Do you want me to take the patch via battery-2.6.git?

-- Sebastian

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT9ljoAAoJENju1/PIO/qabfoP/0MkLBcuHApV6q9ZW8r4DZIu
RpbOZqS0dja5UAuWxGWNqHBsYaOXQH1kFPko+YXMMBSMqoTQ1PBPSEbHvPJSoSW3
DqXjBCM/CWpkaHVQBnzoeaoos4eCLVxeRMNf466gp4wZNOU83yFqeFjF9e5PaEjf
PiZeIe2pqMYE1w4mKHVVbqogyOPeEfBPOkkQcF+/OmrV3UiIONCh2MC6Rl0cQgS+
UhoBX7VdhDnGUVgg4Gqef8Or3CNNLdbayo1aZutj7JdANMCTVPGVgQLnvyKtUzGG
C787B0aQoioHzfp5k7BhPmc0oIOgbcp8Sa6GIifwPXOg7xnpmYrm4tAsy0duxwZO
q7f+N6ww4LgNlYhywuSF+bMgfJvrO0GwdkdePqiNGs0hQfa5F4ywPdeE2oCGf9Do
ie3MtSdVlHrCKVdcRXqJKdDq0t+GmTHNA7KgPqxI/GWnYUPtX8U/4Xo3lrDJgez8
S2IHbvgmIm/mssSpZlMqlFVyjGqXq1OJpzVkl0V89KuIJuweusBZmU8UNdalwsH4
rthyji1YS8sTjOactdYj9j2ttcWlMUfg1aUpiUjxMkXXWYAQ9hqV4pyytkMP942w
Abr0kgD0Qeu24vEM6VR2C1oDybmTiZSghJEDfo6G48LxFSGdvQxSMPir2siz4dtL
CXiLUqCSu2baAt4Mk58z
=28qL
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--

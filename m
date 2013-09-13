Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3IMKcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:32:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42470 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3IMKcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:32:18 -0400
Date: Fri, 13 Sep 2013 11:31:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
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
Message-ID: <20130913103152.GE29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <20130913095950.GA29403@sirena.org.uk>
 <20130913101611.GA7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jNrv5tQKhTiGHXva"
Content-Disposition: inline
In-Reply-To: <20130913101611.GA7393@intel.com>
X-Cookie: Your present plans will be successful.
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


--jNrv5tQKhTiGHXva
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 13, 2013 at 01:16:11PM +0300, Mika Westerberg wrote:
> On Fri, Sep 13, 2013 at 10:59:50AM +0100, Mark Brown wrote:

> > Accessing the bus isn't an issue for I2C outside of ACPI, the power
> > management of the device is totally disassociated from the bus and the
> > controller is responsible for ensuring it is available during transfers.

> Yes, but since we want to support ACPI as well, we must make sure that the
> adapter (and the associated controller) is available when client ->probe()
> is called.

Right, but this probably needs to be highlighted more since it's a very
surprising thing for I2C and is causing confusion.

--jNrv5tQKhTiGHXva
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMumVAAoJELSic+t+oim9U/QP/jBIbZVAuivQa9jwZnFzNXzp
pNBC0SovLUakD81SnMLL/M56s1Do4S8W25VPU9xMnFIga2Wfj62KjBbk2sfCmU7M
PoQfTbxGuqwc8M4NzS4kQ5DI5x0uXlFqRC6/yG4bsU/HWzYO07askYd81u9GBkvw
CRzF5z45M+aJko3FEpg23tBaASlMkCDPipuUFwqwE1WV3LFAgBGQNbYfLQN5qJru
AeWTgUOWcArPshJtKuYZi8wbjek0Qs438pU0uc/LGEc+e1vz7ybxPnalfwyeEmKd
LkIrNOPPBkJDLdxjfwYslzyg/WTpkhTSO1I8ICs2lvTw+nIJaveZYTvRi+t7bkjC
sqy8NVD1fMUuqjx6PsSoBTo0htJK07Cs7qiItDdC5vgYx0Sqy4Uw7rZzGqnFDJqx
wak1/LnZWcC5yd7JLjcpCyk43Cr64gsEnP4ZSEvYW/GE6IRWkeA2q1nT2qlzWThm
cODhK3rST029z0SVhYd2nEQ7c4W97gzdoVXLpdO2ibD09GzlEeoIm+pWq/nUF2X4
iWEADrxmkrd+FMGpeXwAqvi/fpXMnTPrI9STxPWV/MBlPtkE7JXkk9BOPWL7n/qN
l7IczQmL90MpqKIBJYo6GHuw/esSja7rOH+F+C5h8oVt7B/5XoMqtzPmDLGbWFcr
6nBTfGdUiy7oS4eYhikh
=OceB
-----END PGP SIGNATURE-----

--jNrv5tQKhTiGHXva--

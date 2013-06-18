Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3FRJpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:45:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54398 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3FRJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:44:59 -0400
Date: Tue, 18 Jun 2013 12:43:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 4/9] usb: phy: twl4030: twl4030 shouldn't be
 subsys_initcall
Message-ID: <20130618094300.GS5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R0KbGFzrRdaLlFh/"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R0KbGFzrRdaLlFh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 02:13:54PM +0530, Kishon Vijay Abraham I wrote:
> Changed the inticall from subsys_initcall to module_init for
> twl4030-usb.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

not part of the series, should be sent separately. I'll queue this one
for v3.12 once v3.11-rc1 is tagged.

--=20
balbi

--R0KbGFzrRdaLlFh/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCukAAoJEIaOsuA1yqREaicP/2WvVLB/REUqZXTCmlm76T1R
PjqaZ+/0KujXXMBXjRJia07jVmOyL3S/wliLqDWyve6Xr5QIKpai3rWAyLknoEH0
pU6X8FO0AH/LoMZEdNJ/M6dBNISSYSh/VGitKlFXTrP5T7oCjF6Bre7n7CtIEu5g
RzV8rEAbc4JjFQjejETgDgqfnhmq8OhA1fmuY7ScVoJInRykz+K3rf4Tujxt3JMb
M/IO15hrswpOJM3QiQMDUgEEudsmndaoW3JjFsNGIEJR7ePFSeYMilTqgw/sw7lI
n8jxM3q8UfDsFkNZ7C0ZyhpJG85H4n4jMMN8qNun9HjGkYQkpYmjqHKiRWaFlVon
pVzgUPAjWNxwbosXdU0K/gYyWpTeQl4MshF6lSA9ZkdcdzD7PNoUlXk+eD2z0kjw
AuyaWQ1DaRX3DfsNLtJ4UPiSQO8vITZGg4EiF3LyduDS+QoY2kd8qwQU/D9HDBiX
m6ukYHUT04+luz7Rl2wM680yDZT6RIPc4pJD/N+0xp56wRn52xNLilgssIpuFIBY
qhzZ2MLrjxwjWlu4552UbUbn67QhbQlCSbCMzzHSt17yGY9tiq3CrmvKffgTfgsb
WKpvv7xnbk6Yca4PZ8pLOvEF6p8T4DAY+KEQGyRvSMlJd65UqtPzDkDxxdARc8RT
QBrL8nyqajaJCGYSy8Zu
=b73G
-----END PGP SIGNATURE-----

--R0KbGFzrRdaLlFh/--

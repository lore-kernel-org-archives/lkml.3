Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3A2J6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:58:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45948 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab3A2J6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:58:32 -0500
Date: Tue, 29 Jan 2013 11:57:58 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <stern@rowland.harvard.edu>, <linux@arm.linux.org.uk>,
        <sameo@linux.intel.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 10/30] USB: ehci-omap: Use PHY APIs to get the PHY
 device and put it out of suspend
Message-ID: <20130129095758.GM8708@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-11-git-send-email-rogerq@ti.com>
 <1359453032-20604-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFUYW7mPOLJ+Jd2A"
Content-Disposition: inline
In-Reply-To: <1359453032-20604-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bFUYW7mPOLJ+Jd2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 29, 2013 at 11:50:32AM +0200, Roger Quadros wrote:
> For each port that is in PHY mode we obtain a PHY device using the USB PHY
> library and put it out of suspend.
>=20
> It is up to platform code to associate the PHY to the controller's
> port and it is upto the PHY driver to manage the PHY's resources.
>=20
> Also remove wired spacing around declarations we come across.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

ideally, this would be done generically by ehci-hcd.ko itself. Alan,
would you have objections provided it doesn't break anyone else ?

--=20
balbi

--bFUYW7mPOLJ+Jd2A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRB50mAAoJEIaOsuA1yqRErb0P/02UfB4iZVXRa6a6R6/JXq6W
WMuvCTbn8BUZWEW3qyETWcJcbdA5c5z3msNxeucVMWJynVdl5Y29FoUQeLr8hhEP
zTCwWhk5C9t4XBvc4e2bM8UgHN5owsIQhJJy6oWW3+zkdRUclrZhKFKqQhgS4P8I
rW9uza7ANHdYsEW36TPwwyK67/q67hXZCvtHVcwKzJZtYQHAUICFE/ozn2XBmoiI
4pivz5GCh4XtxOV32UTLmshaOWLcG4r93lPTbg9MLJtmsj1CPpsPcZ69x37Maf5X
cebV6t0rcbJUc7rqoXVy8nJxkQAet7d3vARv0OxWd8T024etUx2X1OA142LB3ECy
br+7FPGe5vDdzrp7bIPqXcNEKH9ImfzD7BLGTBCPrNKqPMtUeQa/YheiYvH0XMy9
yZqPwP6goyhwGVrUiunGMqS56jVV4zcBblXJfGBYInNw5VpdwfCJiTR1nimdHpdh
drameYRaE879IGlRZ+JAr5lqXCzTvTmOzcvDIeNdtBDGk1u7REayuiZCv2nNVGTP
WlpfcULKAzSkszldzM9NtlCusefIWE/VB7YZ/KBghsQoFUSqp+GyoYMSWoz2Ai0N
Ogb9chiq6zkul9IzC5CEVO8PgHjJIQ4wzkEDYNmiW3KjRqWEMbZLfi7DOHXyUMeA
m6VJYXd/FVM+DhJ8kPl1
=Q/9E
-----END PGP SIGNATURE-----

--bFUYW7mPOLJ+Jd2A--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab3FRJrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:47:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38589 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab3FRJrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:47:09 -0400
Date: Tue, 18 Jun 2013 12:45:08 +0300
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
Subject: Re: [PATCH v7 6/9] ARM: dts: omap: update usb_otg_hs data
Message-ID: <20130618094508.GU5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-7-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5Dr6Wqe9hdyl7LAI"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-7-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5Dr6Wqe9hdyl7LAI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 02:13:56PM +0530, Kishon Vijay Abraham I wrote:
> Updated the usb_otg_hs dt data to include the *phy* and *phy-names*
> binding in order for the driver to use the new generic PHY framework.
> Also updated the Documentation to include the binding information.
> The PHY binding information can be found at
> Documentation/devicetree/bindings/phy/phy-bindings.txt
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--5Dr6Wqe9hdyl7LAI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCwkAAoJEIaOsuA1yqREG50P+wbMFDXdqJUwEqn4cges9qiZ
sfdgCIqTk7D201jvxv2zP5ZmITlMj1nX7uml95Xl57V1eLkLHfjxk6oXybdCBa1o
pJcaBe5HAQSPIEcY4pI3+NFgRs/pkjjrHIqRYamEYWroYAcc2917BihITrah69aV
FLV4F0VVN9kkIfvSjVlNrsYz2LAjGjmmwf2Dv8Rvnj6SBiWM2XaUNwRO6gu/eUtZ
7lCAOTnGW3Eo4Uq2vg7GTBLW9FBEtqaH7ieHGDMb7LzfxofyUrdPc93AIQF59Co5
E7ZWBeZF5OQF1acvV38jz1FUvtDmd6N7GzG6p4O0Y2WwVtOkXLGBAaZ7wbMYI3a7
9dSCIcTlLe0uBUZfeIxSUYHXhMHPpYkszy+V8S6uGxy+NHc1HgO3KVhPeS4/p2SU
SDoTOMOAv3fKcgw1BAjChBb7Mz6qBfVjqxQ0q1Gds9cQOz8Rh4LIZVoEx63oNxjw
weQlCsm33yn9R9XNqkaXApXsDx8JYHI5cJCwA0RegXcWDZthDpBd19nii3ooKG8S
Z6+mK6ToNLnTE2mV8MD81TdDNYLw7vs2XRdA1oQhOXBT0JdZG6F6ql77vQ3GZHuJ
R6D9tsPsQNhAV+mRD51upjYQPnHDaRChnCgGfi4+yJdmtrO4ikb4RIFjWnx/2SpO
8w/rIVsuD11aG4HtQyOe
=qTx5
-----END PGP SIGNATURE-----

--5Dr6Wqe9hdyl7LAI--

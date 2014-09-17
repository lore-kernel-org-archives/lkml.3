Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaIQQzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:55:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:45827 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678AbaIQQzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:55:36 -0400
Date: Wed, 17 Sep 2014 18:55:30 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] Documentation: devicetree: mfd: twl4030-power:
 Use the standard 'ti,system-power-controller' to mark power control
Message-ID: <20140917165529.GA24699@earth.universe>
References: <1410957252-764-1-git-send-email-nm@ti.com>
 <1410957252-764-2-git-send-email-nm@ti.com>
 <20140917154400.GE30918@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20140917154400.GE30918@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 08:44:00AM -0700, Lee Jones wrote:
> On Wed, 17 Sep 2014, Nishanth Menon wrote:
> > ti,system-power-controller is more or less the standard way of
> > indicating that the PMIC is the system wide power controller and hence
> > may be used to switch off the system. Almost ALL TI PMIC drivers and
> > many Maxim PMIC drivers follow the same style.
> >=20
> > So support 'ti,system-power-controller' in addition to the usual
> > 'ti,use_poweroff' to indicate that the PMIC instance has control for
> > switching off the system.
> >=20
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> >=20
> > V2: picked up documentation suggestion from Sebastien
>=20
> It would be good to get Sebastian's Ack.

Acked-By: Sebastian Reichel <sre@kernel.org>

[...]

> > +- ti,system-power-controller: This indicates that TWL4030 is the
> > +  power supply master of the system. With this flag, the chip will
> > +  initiates an ACTIVE-to-OFF or SLEEP-to-OFF transition when the
> > +  system poweroffs.

One minor thing: While the documentation is updated you may want to
fix the typo "will initiates" to "will initiate" (or just drop the
"will").

-- Sebastian

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUGb0BAAoJENju1/PIO/qarXYP/3COxHZgxiuoxt2x4BPugsOA
gyuR3HWunXDARYAnhjIKIBvUKqFxbPzai2qdR6dinNu9q704mYtwcBL5WP+xZtbK
zl/d4GVQ5QOQG7GUQ1s5E/YPoAXEA6TbgWnurrzdzRQOyROLyBlj87DTS4AryFf6
8OFOvZr8HdQJOTwY2VsrtxLYI8tFJAwnfXlAZofcmlXUYxEwlnXql2wt+mdn1DcU
/tnLHlCcsgOoJXwLEGcbbYVxoxfPb10vb2+pBy40K22HCT+KYv3GAh4iiv6iS1M7
qAA16HXp06FyfPnAIwuqvD77M8eL9ItVCp8acT7+DiHVV4EkM+D2njOcV3kgp+fP
40pFs4AS+obHAJUQc5sJ5s4FNH2raQiRpjgim8i8V2yJ+rehqeLZm2Dyh/45dQJ8
CnV8BBqvTYLQV4OQ8VVNSqtj1jpA4YrpNvYrqfXGd5ovZU6ZAE7rZhWnfuNgX3XX
CNmTnmhG+VO51uCEA3LpVjIVXlNvSUjbVExs7GjsNFVVchMdPjwji9JAlCBSH/yk
L9x2BQRZgNgQbO2oMkLZo9Fat5AkW9t8q/yO7zmxq5tXiyxsWMFBAxFJHBNq772E
edjvelZpXgQ2e8xty2HT3/FfKpNgz1Y0yWwM/aKOwVWbzcV84q0enlnO89QvhscT
5jfaY2E7epONARknfmJk
=/DFi
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--

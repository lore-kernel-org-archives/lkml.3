Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbaCUNh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:37:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43290 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760597AbaCUNhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:37:52 -0400
Message-ID: <532C408D.4070002@ti.com>
Date: Fri, 21 Mar 2014 15:37:17 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <3632624.gNVi6QOfGx@avalon> <20140320222347.CAB6DC412EA@trevor.secretlab.ca> <2848953.vVjghJyYNE@avalon>
In-Reply-To: <2848953.vVjghJyYNE@avalon>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="G261urBc241986SSMdbrsee8OkqQINdFH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--G261urBc241986SSMdbrsee8OkqQINdFH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/03/14 00:32, Laurent Pinchart wrote:

> The OF graph bindings documentation could just specify the ports node a=
s=20
> optional and mandate individual device bindings to specify it as mandat=
ory or=20
> forbidden (possibly with a default behaviour to avoid making all device=
=20
> bindings too verbose).

Isn't it so that if the device has one port, it can always do without
'ports', but if it has multiple ports, it always has to use 'ports' so
that #address-cells and #size-cells can be defined?

If so, there's nothing left for the individual device bindings to decide.=


 Tomi



--G261urBc241986SSMdbrsee8OkqQINdFH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTLECNAAoJEPo9qoy8lh71PigQAKz1zNAFp441Mj2R8m1wNZlv
CEbmHLRAMyuNykNlVDVfIyPRVtVrv41+IGFknHUdvQl4h8GtKs4z8voyEQlnohN3
BOVIdMtUwGgO+bsk+YQiLOUoKtmi32g3t4gzx2OT9vZo3aWncaP3PbbuzGTTOS50
p37br2P+1hOe2lcVYOPMcUq+C31x5gbGJGLN63QqwF4Nz0ZZKq5l7A3a6AMsdRFv
K72llCJouxRQF5nOmiaSyCJgEUsVeYtzy3UY1TaqMrA6d2xEb0hH3f0EwPuSDRmo
dVzFLN806uDdKbdO9iJs2pZOkQoppmsEATCnCS+JtIYvcXOIxUDUJ82ie3Y5ku55
2ovqyKQHKOR9QKMDqfK1i7+MyxwAk0RJYgIEq8nudcjyaFsOVgFOqp9PHy+hZTjL
S4unO8/xULDHkMgewEzBsQbjr1MaEazWRpzQBe3GRxppkCaT7LmwrhIrFKHgiUo+
DxDp8pmHUcvyO2z+gMWCb/Nt3xZizyCoeD8gEkY2/Y4IqDsdkOFlyxA3yQXvTIMv
AM8CBCrUliaFyQtM+sp1C6aQUpUUYdmqYnmrmqXuMkNyYM+BjBlfYw0U1ggiBcmY
+HFypZAX8vKx8MsmvvB8hYpMExyMdWMC7ba4osVOFi7a3J1rDlGBJCYwj0nH8Vhf
J2YuELr2WaRtOhT/azuB
=4DEJ
-----END PGP SIGNATURE-----

--G261urBc241986SSMdbrsee8OkqQINdFH--

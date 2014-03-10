Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaCJGyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 02:54:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53478 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaCJGyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 02:54:12 -0400
Message-ID: <531D6178.3070906@ti.com>
Date: Mon, 10 Mar 2014 08:53:44 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>	 < 1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>	 <530DE8A9. 9050809@ti.com> <1393426623.3248.70.camel@paszta.hi.pengutronix.de> < 530DFF4C.8080807@ti.com> <20140307181132.B2D71C40A88@trevor.secretlab.ca> < 531AE46A.2060808@ti.com> <20140308122532.1AED9C40612@trevor.secretlab.ca>
In-Reply-To: <20140308122532.1AED9C40612@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="WP4PXb977ufAdKbrgTALpgqOPLJ35eEu3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WP4PXb977ufAdKbrgTALpgqOPLJ35eEu3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/03/14 14:25, Grant Likely wrote:

> Sure. If endpoints are logical, then only create the ones actually
> hooked up. No problem there. But nor do I see any issue with having
> empty connections if the board author things it makes sense to have the=
m
> in the dtsi.

I don't think they are usually logical, although they probably might be
in some cases.

As I see it, a "port" is a group of pins in a hardware component, and
two endpoints define a connection between two ports, which on the HW
level are the wires between the ports.

So a port with two endpoints is a group of pins, with wires that go from
the same pins to two different components.

 Tomi



--WP4PXb977ufAdKbrgTALpgqOPLJ35eEu3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHWF4AAoJEPo9qoy8lh71aRgQAKa7NU6vFHKIcaTLCOscqUQI
6XDQQ/gFmiCqwNPAeWp6UBoQVUi/Q6xSWnbowVHuNExBXV+uyWg44am/4KuUWFaG
5WrZeEmOd44tF/eHnmPLK5PhRtoN47xqg7H1Gj27QL1AUUfN7ZXnLOzFKaK/oEGL
VpgllJv5QfEiyUUqcBqNE7xaGm3iU+c/FyjNJN10UOcJdGA2iGosKIe3XDJ2o/CG
BNHw+xJpO0XrrF7AQ/cGWh0c0rafV+CuDNqJ+CsxH9XgvSbj53E18OnPMl56v3dU
3rR8km3NOAWTM/GSIkZ1Rix/WzLHPwAH/0Yk6l6vKNSsMSQSe2nm6uN1Kpjqruf8
uWIgEhXIxImpyV1jDhfVhFJl5xxtRgZ1uxIOCtTxfYjr54TFuFJucLN5HeJW/JG9
j2UjOUNUIuq084vZfBm4fQ9BHj0hihAx+dhxNTSq0x7wix03xuH1p0nTYKLjIVt4
rqw53MjaLLTs7xYgTW463b3deeqYxHVVo9HQ6XFo/ia8i9WOqZ9zvEKQtoh5Xdjo
9avt1l3POVbBssa+9Ue76nbvf/1zAqBFEMrxuwIy0uIbrsCZZQlEhZe2WKsYnsQ0
OtrCKIqKis7jyjhofRvT7WTgAy5I54NdK46wMHW3boTHAWHOExg1FjgL5fetkKK1
PoZSm/JWdBVpl2n+gqju
=8ACb
-----END PGP SIGNATURE-----

--WP4PXb977ufAdKbrgTALpgqOPLJ35eEu3--

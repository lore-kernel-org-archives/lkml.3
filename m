Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaCJGAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 02:00:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56802 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaCJGAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 02:00:36 -0400
Message-ID: <531D54E2.8030303@ti.com>
Date: Mon, 10 Mar 2014 08:00:02 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <20140307171804.EF245C40A32@trevor.secretlab.ca> <CA+gwMcfgKre8S4KHPvTVuAuz672aehGrN1UfFpwKAueTAcrMZQ@mail.gmail.com> <1536567.OYzyi25bjL@avalon>
In-Reply-To: <1536567.OYzyi25bjL@avalon>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="DeQCUmhTJf3eaP0IppoJdqa9WWp4raOCE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DeQCUmhTJf3eaP0IppoJdqa9WWp4raOCE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/03/14 17:54, Laurent Pinchart wrote:

>> Sylwester suggested as an alternative, if I understood correctly, to
>> drop the endpoint node and instead keep the port:
>>
>>     device-a {
>>         implicit_output_ep: port {
>>             remote-endpoint =3D <&explicit_input_ep>;
>>         };
>>     };
>>
>>     device-b {
>>         port {
>>             explicit_input_ep: endpoint {
>>                 remote-endpoint =3D <&implicit_output_ep>;
>>             };
>>         };
>>     };
>>
>> This would have the advantage to reduce verbosity for devices with mul=
tiple
>> ports that are only connected via one endport each, and you'd always h=
ave
>> the connected ports in the device tree as 'port' nodes.
>=20
> I like that idea. I would prefer making the 'port' nodes mandatory and =
the=20
> 'ports' and 'endpoint' nodes optional. Leaving the 'port' node out slig=
htly=20
> decreases readability in my opinion, but making the 'endpoint' node opt=
ional=20
> increases it. That's just my point of view though.

I, on the other hand, don't like it =3D). With that format, the
remote-endpoint doesn't point to an EP, but a port. And you'll have
endpoint's properties in a port node, among the port's properties.

 Tomi



--DeQCUmhTJf3eaP0IppoJdqa9WWp4raOCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHVTiAAoJEPo9qoy8lh71qmsP/R2b9WW0b8zK1ws3LrxX5baI
pWob+wLoTEpUFnXtL6lWq4PFt93fKHnyIJl4TvV0P2qlxYg5Fh1rrX4pQaN3J1eE
2K6WxzPu/yQmWKsl1iiq9e140bBzWDkiCXsXIVYLtHK7TyZ0kXoT+yZVGGy+JZtd
gSbS6+yqhUpsfOBaGHEdx4CQ/OIKIBERwmGtdM2cT/CtQpEvx5rcwtO2U33VpSDP
jjmGTF1lqJWQXtwbnXgFKSGAswhW03RFgYxKlEQYwB0srVY3cxf9pyFxsRaIBV/H
FBgSwVBilYP8u59WnhRLAD7ECftmcc0Lac0R0eKoweIbUOFaAscbSPXngVf839Jl
gj/6fMV6V6xYlxmJl6cIk5WX9yHz29zu1n4Fw5HBeF7iXP6Htg+ATnk5SJKEYtc7
VsVji9DpqUmB/hkUl4QSJsy4zT7pGKg1PQ/h0+qmdLMrFOWJLPy4doVnYxIF1nKE
rNmCGXGfiArPSNUYTTy7Q26joMR9o6V3P8M1HKT5KVjoBg7OR7mBK7pLREUHDGKI
UBCqUAbHYUotPFE8EOUiLzEGFmflMzFw0x1n2PYQQ4pdvnhWPmZE/hnntlFIEgp1
rPF1C6OQTh8nje6iTMbMhQ+Bc9RfEsrNSgeHSP+k2MTR/HEXpLUFwxMbcEDJm9eX
j/buX9gTycsHqihIukW7
=+/pa
-----END PGP SIGNATURE-----

--DeQCUmhTJf3eaP0IppoJdqa9WWp4raOCE--

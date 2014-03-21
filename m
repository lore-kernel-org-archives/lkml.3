Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbaCUOXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:23:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45361 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaCUOXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:23:19 -0400
Message-ID: <532C4B3C.4030406@ti.com>
Date: Fri, 21 Mar 2014 16:22:52 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
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
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <2848953.vVjghJyYNE@avalon> <532C408D.4070002@ti.com> <1755937.SSGT2MZJMC@avalon>
In-Reply-To: <1755937.SSGT2MZJMC@avalon>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="TpKimeAtlT82Mp8Dp6nm0aT5FTdRosD2V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TpKimeAtlT82Mp8Dp6nm0aT5FTdRosD2V
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/03/14 16:13, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> On Friday 21 March 2014 15:37:17 Tomi Valkeinen wrote:
>> On 21/03/14 00:32, Laurent Pinchart wrote:
>>> The OF graph bindings documentation could just specify the ports node=
 as
>>> optional and mandate individual device bindings to specify it as mand=
atory
>>> or forbidden (possibly with a default behaviour to avoid making all
>>> device bindings too verbose).
>>
>> Isn't it so that if the device has one port, it can always do without
>> 'ports', but if it has multiple ports, it always has to use 'ports' so=

>> that #address-cells and #size-cells can be defined?
>=20
> You can put the #address-cells and #size-cells property in the device n=
ode=20
> directly without requiring a ports subnode.

Ah, right. So 'ports' is only needed when the device node has other
children nodes than the ports and those nodes need different
#address-cells and #size-cells than the ports.

In that case it sounds fine to leave it for the driver bindings to decide=
=2E

 Tomi



--TpKimeAtlT82Mp8Dp6nm0aT5FTdRosD2V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTLEs8AAoJEPo9qoy8lh71GcwP/0kBttUEuj1RVh9tRFqGc3h3
HiU40Qo60ze7+tEaPrNlcQg4RCWU5UgmVplxgqmArXM4NjCFhuwDXt0saxO7igmk
KaC7o6Quguve2NvhWKSj0UUmZGHQ5fTZtRn53jFI4xRLwhctAkLFM2iVGR3MGmgn
O9LeY7gZ3yo4Z7jwYUX0TpZIaPEWMGFk/xeH7/0p6AWysjd0jYxRPUTRXMdCYVjE
gi+/TBx+xhFmJ7t0fh44UVmeYAAySs7j9RbS9ZWH43tEqyA8KXTeH9ZXXtUBcGXE
AQIqubLUtyGBDmh0jpyIR8TC5mWcHFzcMugmP0Gybj9DAG5ZAGGEvKnjnJAb9Doe
AHeBY86Vi4QK5qngsJCIhXjgsj+8oIqVLLbqgx0yXPqS196XdiXttC1tP90FGZf4
5P0QIqgiZhiQHoTi/lbGT225bY3KhPbeIY5g+6eEQNdadX2TGcqxhVWIV3B4QBlb
q7/k6YDv0YX9wN2VDgFSUUVz5SzBaXyO4cwhWp0JNGhe9zDDfaMrfN55GYivE3A/
ZajvfVXGvPEEYPEH4bMZTTu2ziMNafRVhiTsAbAiJgNKOYyVhmf5d3BI8iKS9SeY
3c8lkTuwK1LB/ca0WtTZKDrWIu0jZXuz37NKOSTM+0HGDgbPjxrDwYIsMe7NTYyQ
+E318fWANuKomR4MFuEG
=Nnlz
-----END PGP SIGNATURE-----

--TpKimeAtlT82Mp8Dp6nm0aT5FTdRosD2V--

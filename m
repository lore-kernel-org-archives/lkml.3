Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaCNMor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:44:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54393 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaCNMop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:44:45 -0400
Message-ID: <5322F99D.5010009@ti.com>
Date: Fri, 14 Mar 2014 14:44:13 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>	 <20140310143758.3734FC405FA@trevor.secretlab.ca>	 <1394708896.3577.21.camel@paszta.hi.pengutronix.de>	 <6341585.ZqkoDDr3Wb@avalon> <1394799579.3710.24.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1394799579.3710.24.camel@paszta.hi.pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="KA24mhi9K0IRDKWUGcnpMUbHsRpxoAKV0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KA24mhi9K0IRDKWUGcnpMUbHsRpxoAKV0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Philipp, Grant,

On 14/03/14 14:19, Philipp Zabel wrote:

>>> People completely disagree about the direction the phandle links shou=
ld
>>> point in. I am still of the opinion that the generic binding should d=
escribe
>>> just the topology, that the endpoint links in the kernel should repre=
sent an
>>> undirected graph and the direction of links should not matter at all =
for the
>>> generic graph bindings.
>>
>> I would also not mandate a specific direction at the of-graph level an=
d leave=20
>> it to subsystems (or possibly drivers) to specify the direction.
>=20
> Thank you. Can everybody live with this?

Yes, I'd like to reserve the possibility for double-linking. If the
endpoint links are used to tell the dataflow direction, then
double-linking could be used for bi-directional dataflows.

But this doesn't help much for the video drivers under work, which I
think we are all most interested in at the moment. We still need to
decide how we link the endpoint for those.

I'd like to go forward with the mainline v4l2 style double-linking, as
that is already in use. It would allow us to proceed _now_, and maybe
even get display support to 3.15. Otherwise this all gets delayed for
who knows how long, and the displays in question cannot be used by the
users.

Deprecating the other link later from the existing video bindings would
be trivial, as there would basically be nothing to do except remove the
other link.

 Tomi



--KA24mhi9K0IRDKWUGcnpMUbHsRpxoAKV0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTIvmdAAoJEPo9qoy8lh71zWwP/iIP05q2MrbNWZeC0cHIHgp+
Ows7K5m5RmKr0EufBbj/NeXmIco0pUUWRvy6iKl5xeWrfI2cA1AgYvzN+BUTLuFF
EeWg/X/YlegM7onOCMyCYarrHeOaHDD1v/gJ4tL0sID4eAmT4vxK+tn8d8pdcH+A
JmjbaFBwlP71YN0hqCTa1zL990O+8370bZCS8m8P07Y6Owkj1iaKQVjMUnSxczRw
sDYsjRvzB2hfadG2/Z7N+scDSggZHjSuD3JxV2En8OgNe+N2SNHnZe7UttzA6/d6
DLSkYBo4Q+6Mv3p+n+E0Q5lgWwrA2t6593Z7FIZHgNi5F8DbgHAnBnvb2yd6zQx2
tGVw8EPzpdtBoanRVCyfrtZyQTl/EBaGGNgznKWWEcgPbiI/hmJN6PRboAjZFsRg
FM5DI5xXtqdZjcJoiEY0cMDyi2KjNobCWrJjZoJ5jmqBACyHp382nUqhIYJpO7mG
fkDEDXb6MWRhBZ16zGIkEbWL/kshVvehjMtjfzBBGGaZNyaOb0ls0vzxiKx8C/gI
518GjnaqQC4TC/zEMLaP56rZD0GjUGVq1XaT0w7rN3J+Ycfvh5fDwmTAC/zWuquq
CoS8Xp09GLjTWTUxgF0w4Cr0A2Q1BaL/vlC/mFVz9/hm2zBgmmWRpK93voNyxhJx
koBq8Un5MwXWcfWYH98O
=EJ8A
-----END PGP SIGNATURE-----

--KA24mhi9K0IRDKWUGcnpMUbHsRpxoAKV0--

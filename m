Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbaCUIVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:21:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59143 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbaCUIVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:21:19 -0400
Message-ID: <532BF663.602@ti.com>
Date: Fri, 21 Mar 2014 10:20:51 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140320153804.35d5b835@samsung.com> <20140320184316.GB7528@n2100.arm.linux.org.uk> <4700752.xAVjk21KIL@avalon>
In-Reply-To: <4700752.xAVjk21KIL@avalon>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GQjohDmXS004Jp4GEJC7p5QfgVXm1Awk6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GQjohDmXS004Jp4GEJC7p5QfgVXm1Awk6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 20/03/14 20:49, Laurent Pinchart wrote:

>> The CPU is the _controlling_ component - it's the component that has t=
o
>> configure the peripherals so they all talk to each other in the right
>> way.  Therefore, the view of it needs to be CPU centric.
>>
>> If we were providing a DT description for consumption by some other
>> device in the system, then the view should be as seen from that device=

>> instead.
>>
>> Think about this.  Would you describe a system starting at, say, the
>> system keyboard, and branching all the way through just becuase that's=

>> how you interact with it, or would you describe it from the CPUs point=

>> of view because that's what has to be in control of the system.
>=20
> DT has been designed to represent a control-based view of the system. I=
t does=20
> so pretty well using its tree-based model. However, it doesn't have a n=
ative=20
> way to represent a flow-based graph, hence the OF graph solution we're =

> discussing. The whole point of this proposal is to represent the topolo=
gy of=20
> the media device, not how each entity is controlled.

I agree with Laurent here. I think this is an important point to keep in
mind. We already describe the control graph in the DT via the
parent-child relationships. There's no point in describing the same
thing again with the graph links being discussed.

 Tomi



--GQjohDmXS004Jp4GEJC7p5QfgVXm1Awk6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTK/ZoAAoJEPo9qoy8lh71OQEP/3ts3WNl27wegIsy9M/GghOL
ch51JW7ebSxMfdSlJwbzrbQ5+m2+zYpuQch+r2z5KwZ1EzNAX5qE/qJbcut4owoF
RxRaRN+gfmiC87lU8/fXzc6xZ/+aNhHmizlEAhHTQOSRPG/jyoi6j9wOUO50NGWI
Dtd9KIZDJ6u2oEFMJQkwccL/6Y4Q0GaEWL4kDAN2IUAPO68N6ldkebEnA5g/MzDI
REGXoRxPBn0P2B4gAitYilrKoy3Q+g/dygSWUX36RM7A1fVLC/HQiXOeeba4cpls
eKXOYYC2JSOaDikqjvdLnrDxs/dacWh5YoGicz0LSKxA25j8MQCMwThn1iJHmT8H
IY2+X9egdjLglodXMHlG5Nj9NhcZgQJjuSENZL62/A/Si3ePWPIZrySW722LItc0
E22b9NS9gkwbmoSOCvTdu16GbfFJYGNSYV/Fl+f93FdH5Cj52DRLlRLdUFzj8DNk
LBiIU51EHtJoXikwxwIENgPWCesLjXnq36dZNvrT3xFVCs+1G2bLs3eh8AHM6lQB
FCmtBdSQynxmX4SGnB4lFS2EEakDOjIHF1HgoI6NS8o3JQXaHdQdx0LxzkLulEIo
POdL78iH6SOMnk8v96LTptYAfEFmUimTwutiRJs/vN3TjYRGA6JLXAARlPae9V5X
5D21h1E0X8r86x5q6iIS
=R99w
-----END PGP SIGNATURE-----

--GQjohDmXS004Jp4GEJC7p5QfgVXm1Awk6--

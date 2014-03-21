Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572AbaCUMQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:16:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35248 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCUMQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:16:41 -0400
Message-ID: <532C2D94.4020705@ti.com>
Date: Fri, 21 Mar 2014 14:16:20 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 139468148.3QhLg3QYq1@avalon> <531F08A8.300@ti.com> <1883687.VdfitvQEN3@ samsung.com> <avalon@samsung.com> <20140320172302.CD320C4067A@trevor. secretlab.ca> <532C1808.6090409@samsung.com> <20140321114735.3E132C4052A@trevor.secretlab.ca>
In-Reply-To: <20140321114735.3E132C4052A@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="9LlUb069OlpdAjBJaW3weLxU5bDgBtkGp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9LlUb069OlpdAjBJaW3weLxU5bDgBtkGp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/03/14 13:47, Grant Likely wrote:

> I'm firm on the opinion that the checking must also happen at runtime.
> The biggest part of my objection has been how easy it would be to get a=

> linkage out of sync, and dtc is not necessarily the last tool to touch
> the dtb before the kernel gets booted. I want the kernel to flat out
> reject any linkage that is improperly formed.

Isn't it trivial to verify it with the current v4l2 bindings? And
endpoint must have a 'remote-endpoint' property, and the endpoint on the
other end must have similar property, pointing in the first endpoint.
Anything else is an error.

I agree that it's easier to write bad links in the dts with
double-linking than with single-linking, but it's still trivial to
verify it in the kernel.

 Tomi



--9LlUb069OlpdAjBJaW3weLxU5bDgBtkGp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTLC2UAAoJEPo9qoy8lh718O4P/R4CiDBud/awWEW/w8LmG6P/
CxswSoraEyr7O2Mbwlq+Dl3jY7B6LK4I6+1TN10ooV4dEQeUbApNg/qin+6mjlum
GiaQwZuvZ1dT9qAKF3MYkRJa6csRqIwvSgRDF6EH6f5ur5IY8t9hv+Ll/ZsQbkL5
bsIVgrfcuBgPQiV6+QB+CgzW4xKBbe/6hniiub2y+Yf3gDlTFO4eU07Q26R6kvbM
89DBo3deSomyRKg2+BKj+xauxz8rysf4Pcog7EZHvR83iegqiqAaw2k5p1DNjhpm
nGo7rnOoELT9+WeqQ3gcIK5E2FLhag9Iahuzi/6SPEI+kwb7iHc3ENE3qgOtpHVp
aeqelBgQFX+rDFdM1U8v1HdP71wQ0pHSKQxFSpUE/F+ZoEfxOVQ3cBjm69+jVXAl
BVbczCSQ/9aMr6KPwJtwDskQqL6LqP/PnMg62T7tBwka0W6pK7zUX9VgmOwQ1ruP
0M6DGNGzv+kRTO7j8XD1WuHE0aPVHQHLl3ZwZta0tJc1h0tMWR8TbgtavIqqQkwC
dSKOzEKkEL0Ik0iqthQuZuPtK06hBRKRIpDIUMuB8j/N30F2PlL7xreImvslqgQs
oi7eHLzTIxnDLDlWVFa/IzRg30I8aA/37iYIS0Ywn0LrgJV88y84CoXrlSDUsPkR
xaP2jFwuooy8Y4ud8JrS
=m22+
-----END PGP SIGNATURE-----

--9LlUb069OlpdAjBJaW3weLxU5bDgBtkGp--

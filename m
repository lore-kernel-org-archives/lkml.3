Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaEQUsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 16:48:13 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61284 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaEQUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 16:48:11 -0400
Date: Sat, 17 May 2014 22:48:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140517204805.GA1046@mithrandir>
References: <1400242998-437-1-git-send-email-thierry.reding@gmail.com>
 <20140517170455.08e181f16d3abf36d1ec6274@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20140517170455.08e181f16d3abf36d1ec6274@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 17, 2014 at 05:04:55PM +0900, Cho KyongHo wrote:
> On Fri, 16 May 2014 14:23:18 +0200, Thierry Reding wrote:
[...]
> > +Examples:
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Single-master IOMMU:
> > +--------------------
> > +
> > +	iommu {
> > +		#iommu-cells =3D <0>;
> > +	};
> > +
> > +	master {
> > +		iommu =3D <&/iommu>;
> > +	};
> > +
>=20
> Great work, Thierry.
>=20
> One simple comment.
>=20
> This should be also applicable to multi-master IOMMUs that the masters
> of an IOMMU is not configurable with ID or something.
> I think the title needs to be changed to cover such IOMMUs which always
> translate master's transactions and unable to change the configuration
> of the relationship between the masters and IOMMUs by S/W.

Agreed, how about we add a separate example for that case:

Multiple-master IOMMU with fixed associations:
----------------------------------------------

	/* multiple-master IOMMU */
	iommu {
		/*
		 * Masters are statically associated with this IOMMU and
		 * address translation is always enabled.
		 */
		#iommu-cells =3D <0>;
	};

	/* static association with IOMMU */
	master@1 {
		reg =3D <1>;
		iommus =3D <&/iommu>;
	};

	/* static association with IOMMU */
	master@2 {
		reg =3D <2>;
		iommus =3D <&/iommu>;
	};

?

Thierry

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTd8sFAAoJEN0jrNd/PrOhGXIQAJOqRSklMjl4lFQfRhWaoB3m
pYpRwqjrA0rLzEb+u6bk5Kv4kLRK5wOYr6Fd/y8DYONY+vZ0SXBOgEo7uv/mXURM
R2m8tTiKLtmQm6xZ///FmcU98lOZM+l6Vv3/F+QVH/41RRNTzTXXir0q2XTYG5wU
Fefylq654a8Ha1rDN2Y6kPt4P/1Q0tuA/7Z0jidDYXK04Pp+5QTBUHSFAYJ4V1Q3
HuH2XmCioGRTem4cl4SMM6uA+IrnuZcXePrNT35HwtN6bmSe2IKNxaK+VKvnVzza
Qc0hvQEDdsjijs1Fy4rY3zPhkvAGz/rbs6nYUJpRl96R3Zb5sKaO2Vqj9glLX5/e
B5/wv5yVSs/ygRLW8/E76LXB2PNqkVg68smSRGrA/7q7iU2/ZUatnqoVCTWT2Jid
0zUkBur8KM0wdBrowgrs/sVzFvS5Ii/yUyyfXJQWZELkhEo681LGGNt7PXYugjtr
P//6zQwn1ogR7xq+7hCcy5yZAtc8UrXyIRF9/XrNvdGhg0zXdaQa1viM5AapeLGs
WAPwb+KlFvXxG/8EY96Y59LvULcP5oGhwMXkUrkvH9OiDzZXIVbEZfrtCvKhUzn6
G7CzsIQr4Q3+5u42Ndt94WglpdiDfVeUmh6ofv34rTZHqy7MGpybJBp67qf0sff9
wO7Z6vqP8a7m/yZuQ7tr
=Y4ib
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--

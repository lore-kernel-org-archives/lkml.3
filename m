Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaANNNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:13:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51524 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbaANNNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:13:46 -0500
Date: Tue, 14 Jan 2014 07:12:23 -0600
From: Felipe Balbi <balbi@ti.com>
To: Suman Anna <s-anna@ti.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 0/7] omap hwspinlock dt support
Message-ID: <20140114131223.GC10818@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <1389658764-39199-1-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2014 at 06:19:17PM -0600, Suman Anna wrote:
> This is an updated series mainly addressing Mark Rutland's comments
> about hwlock specifier being always one-cell. The series adds the
> support for #hwlock-cells property and adds a simple default OF
> translate function.
>=20
> The DTS patches from previous series have already been merged, and
> needs this property to be added. This is handled in a separate series
> that only deals with OMAP hwspinlock DTS patches.
>=20
> The series, along with the DTS patches, is tested on top of v3.13-rc8
> plus Tero's v13 clock DT series and Tony's 3.14 staged branches. The
> validation on OMAP5, DRA7, AM437 requires Tero's series with couple of
> additional base patches for AM43xx. AM43xx functionality needs a hwmod
> fix [1] for creating the associated omap_device as well.
>=20
> The validation logs on all the applicable OMAP SoCs are at:
>   OMAP4 - http://paste2.org/YJ7ZwG80
>   OMAP5 - http://paste2.org/c6vO96b9
>   DRA7  - http://paste2.org/tHvxN439
>   AM33x - http://paste2.org/AjCv0U4t
>   AM43x - http://paste2.org/2AKIPa55

I build tested your 3.13-rc8-v4 branch with the same script I used to
build CCF series and hspinlock built without any problems ;-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS1Te3AAoJEIaOsuA1yqRE01gP/0tYtg9gUL311bYUBeE8gdXA
dWm9JPdFYwVIhjUmumMuwlCf7L4QnDPZibWv4S6MAfNuj4j+GdNWMqHVEWdKLp4c
s3Y2E6Qh3ej/LycWMBwo14VX5KVO1yLK37MZ9q3gnxokbNOt27a/fY7AtDdDhnCz
vC9Bk+9HGN8ueyLFIIsja80KixctbXBI3O9aWhu3XIuVQVEh6C6+alpFxpScytK5
uJWqSKulZONDQjuAW1yTejfDTltyvv4100E3oTmiIazHrXGg+0l0fO8Co2YmV3/p
jN+XCrXz9CvJ/GB2l6PBv67DtaXg8gp4YxKcEokxHvcwOYvF6lWXtSWUo9ZYx/li
SV7yjXi4gUi2YbAsVZFnolCmUuXLAQ91fx0Axh+BCXK+ZJTmlQXHy5VM1O2Oyoem
cgjoKfIxEZzxdbJ5JpaAJf9Wsq+91xcRrXulXtjrSGNrrR4u17ZB7OKTY7uoCZxb
hz8vac4D1Eav8YmFjAdxvfYlfwfcSP2yD7Q8Pb30ScT0/0xD5A+2cbA5q9MrsAUv
h6GLhE2KiWbTo7Xg3M2gKKGfzA7LldJfq1T/AU0PnetOvCwEcfzMTdwxGFpwDN5/
s0JUnbesGkm24G8tY1+M5F29UvqsMnAy0YQFMfQEFBGcBbeOl89uVvnqe3YFKrwT
wx1DLS+4BgVMs7mCPFPF
=FjsK
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbaGXOZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:25:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:43819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759178AbaGXOZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:25:09 -0400
Date: Thu, 24 Jul 2014 16:24:57 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH v2] power: add driver for battery reading on iPaq h3xxx
Message-ID: <20140724142457.GB7743@earth.universe>
References: <1406210432-24936-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <1406210432-24936-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, Jul 24, 2014 at 04:00:32PM +0200, Linus Walleij wrote:
> This adds a driver for reading the battery status of the
> battery connected to the Atmel microcontroller on the
> iPAQ h3xxx series.
>=20
> Based on a driver from handhelds.org 2.6.21 kernel, written
> by Alessandro GARDICH.
>=20
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Clarify that 100000 ms is 100 seconds
> - rename doubly-named local, infix power supplies with "power"
> ---

applied to battery-2.6.git:

http://git.infradead.org/battery-2.6.git/commit/00a588f9d27fc64f0c64dcd4abc=
8e35ed331afb8

-- Sebastian

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT0Rc5AAoJENju1/PIO/qayrcQAJUi+EVBldd2vj7sAEJXhGUC
iHWMKPjX3XsZD7DZh+dPhR111Pd7kloc2x9nv9mxAaVx/tcJhO6DDYAUy6RV5LKG
z99jz24wsr821GokTuzpVMSHJ8jIcmiFGQLG1TQQIm61phpgsU2X6k8lhTplXy/v
4TNjlWw4nsKsEm9FBDfrDQnN0CmR3kHxAyfO5hRSbvCgy54qGdhBZtRPQFt+G7Nx
RxALA2BEZPypFZSS63uKzi3iUmVXjNZOR3GH6uDxCLjfmHQq3wCgIo2mOonSmKi2
CTBQ52RRIG3PTqIu9LKA9DgPQpxal9vNpXXwXsM1dZBkupe76MEAwuruNxQj8saT
6Ed7RNNsNAg5DEepTtj7KiVf6fXUBbF1EBJQTH1v+Nc++q7gjfhJxHD1QDR5aZnd
NibgkG2vR5GOC3ZsyJzKvpfOc+JT6yYK31raMmA4Ws4IeuZXmDm3Vz1ehfveRC0X
6Kimcyh2FmLudjObToz8zX0tPQU+RS5mpdwgZSidFio94750bhuNMzjr0TnUfnCq
CndNrphmcSeXJh9X3OVxeKsrXQhte/nHdSYxcZCrPpoLyy3FacB5Z+zqi6J0YAc4
et+z1TGxBgrex8eA8lf5a4QPNtuMh/XavQAp2yYiaDwwLmk31Gz5QAyvkTW9gfNL
aZ2hLL3FrIa887y7NYjd
=s6tg
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--

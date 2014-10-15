Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaJOWmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:42:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:43437 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaJOWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:42:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,728,1406617200"; 
   d="asc'?scan'208";a="606087816"
Message-ID: <1413412874.2412.36.camel@jtkirshe-mobl>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 15:41:14 -0700
In-Reply-To: <20141015222447.GB20142@fu.3gs>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl> <20141015214151.GA20142@fu.3gs>
	 <1413411584.2412.35.camel@jtkirshe-mobl> <20141015222447.GB20142@fu.3gs>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HmN2m52+kHWDYLrnkpBt"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HmN2m52+kHWDYLrnkpBt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-10-16 at 00:24 +0200, Matthias Beyer wrote:
> On 15-10-2014 15:19:44, Jeff Kirsher wrote:
> > I will just go ahead and create a patch to remove the driver.  Greg
> can
> > then decide to either accept the patch to fix the Kconfig or accept
> the
> > patch to remove the driver.
>=20
> Don't forget the maintainers file :-)

Yep, got it.  Thanks for the reminder.

--=-HmN2m52+kHWDYLrnkpBt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUPvgKAAoJEOVv75VaS+3O1GQQAJNooBhApaywHnYYMXDU0uS5
5bNBrBhfOiwiJiOskruD2qUnN1KJ+aBALxHfs2LhRO1vcRgs4dnLnpVchXIZr38w
a1fUFdQOV7omf8EK0LG1JpVEV2mMcfuB3Ui1hsBQqDVqYCjx4uZrsYLJJKVksq6b
NPYSehJRO2YaLf6O8I+le63KNUXZRc9glEak7CCq91sotFcMY+JRKN5IIOz2hdww
Vt96RQZGKXoVPD4H9p86/TPDE6soPupw78YUMH0OtipqYBXu/hujPvshVFkWJhJ2
EMzRP0ZsYdGZZQRnAH0KpRUto5rpBkxMNsImJwgmqtNghGbUmp14Ttb+lbMjKNVx
dG9TsvBt4DJgfry36H3wCmPdjUT7FmVqN4rwtjetXDqxIEd4BZ3yukElWmX+7phX
MQHe09uAozh6oQE3+KanV/0C8Z4qqBtFltuF4m6/fbgwKbnUsx7sJW4klXS7OLEu
MurG6docbNjBz4MOd3flJ+Z2LCZI4N2ZiAsjcDE/mAnpZffqD0OL7QS/EJqRDQNZ
IX+JXanf7KODB4qE1X14hRjhn/2+LMT6J5iT0fTZp/rJBhJCy27/Wk89Fy8qGdFV
ltVEPgFxJZ5Qyn1RUC+Qz9XJtAWe6FsLV3qMj7EvfABEg3oKDpt0QxC3/wx9oF0z
3Et4ukl6fHkEuQULGktp
=YJm7
-----END PGP SIGNATURE-----

--=-HmN2m52+kHWDYLrnkpBt--


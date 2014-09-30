Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaI3IkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:40:00 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39726 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaI3Ij5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:39:57 -0400
Date: Tue, 30 Sep 2014 10:39:53 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more
 standard place
Message-ID: <20140930083952.GA4059@ulmo>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
 <3849580.CgKEmcV7as@avalon>
 <20140930093757.003741ac@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20140930093757.003741ac@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2014 at 09:37:57AM +0200, Boris Brezillon wrote:
> On Mon, 29 Sep 2014 23:41:09 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
[...]
> > Incidentally, patch 2/5 in this series is missing a documentation updat=
e ;-)
>=20
> Yep, regarding this patch, I wonder if it's really necessary to add
> new formats to the v4l2_mbus_pixelcode enum.
> If we want to move to this new common definition (across the video
> related subsytems), we should deprecate the old enum
> v4l2_mbus_pixelcode, and this start by not adding new formats, don't
> you think ?

I agree in general, but I think it could prove problematic in practice.
If somebody wants to use one of the new codes but is using the V4L2 enum
they have a problem.

That said, given that there is now a unified enum people will hopefully
start converting drivers to it instead.

Thierry

--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKmxYAAoJEN0jrNd/PrOhrhIP/3jjnDqX/QImd1jjH7oGl5QJ
ssO+yI2OHb6idNZKO/OMWWe60pPl/iBJ6nZhPJbOM4dbeWyOwxtp9jk7KXugP6kJ
JJ/hlWMxZjLeccVVsxJHjnOP6yWuhyaiGnDvUP8K3V+6BAsWTxMxFlnTasxl5n4y
flNVQ7RHVrNR8nsce3R7h/nX72h+2y8oIvNcU9FhZyQkPCrmPpGpJodMO2pvmjg4
fZFadrG2fiYJUSNoTngkVPdOr9Xgd+dImUK7qd3XYsHpcWI7AYWT82LCyEdigwpq
mplusaRFL5orDfKn9gq0a7Iq1jpQS1u7C1Yz0BVaBaiD1x2U0MDeaycmazDIkoai
d6d/QW0rrVT2Tp9ytdYMfiJi9i+xbC96fAEQS6pocbWSla/joiAGg6GIlsjR5W2d
U1tlWMXl2kU8hl15BQKxv+R0eBMd2LolpX61brZX7RrRch3xeH36XktHa8im/XNu
TvI5Zw1lCVGn9PFf/bf3tNFfk8J6AZZ3ZaNUODzCkE1uAQ0EEeCMYYicjcut+RT2
6zPYG0TxNNxAbHcVcz2iVlL46vuedtKtqDtQQPfEtIz/8KSgSPN3yhxEGn3F6FrN
58llTcvzsj3/hdKVVNT13btt3/HBS4noBPiBtuMgFbFioyW/lgzYoK9OkEdOkI52
DaZHF1mzvLdPHegfshX1
=S5MJ
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--

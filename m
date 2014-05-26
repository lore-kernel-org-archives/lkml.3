Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaEZNiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:38:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43128 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaEZNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:38:16 -0400
Date: Mon, 26 May 2014 14:37:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140526133708.GD22111@sirena.org.uk>
References: <1400901043.11911.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWtvayRuroyN98H5"
Content-Disposition: inline
In-Reply-To: <1400901043.11911.2.camel@phoenix>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Use map_voltage_linear_range by default
 for list_voltage_linear_range
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWtvayRuroyN98H5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 24, 2014 at 11:10:43AM +0800, Axel Lin wrote:
> Use map_voltage_linear_range() if list_voltage_linear_range() is in use and
> nothing is set.

Applied, thanks.

--cWtvayRuroyN98H5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg0OBAAoJELSic+t+oim9uZcP/3ra3+JnUHSB2gj2ugdWCr26
D7sEkz+1xjndMw9VJuxiCoJxiEN07tJF8NkbSSRx1y0elLZ9bQp1BX703Q9CDD3H
KDrt3BkVaC8zh8j8p5kqqNv9SYiZYCYP/Gb8W1hEwbzRGiY6WdQZTfZRr2JS8k57
yBDOHzX9D5y0hAWbnKbmiddujIPhC5SfLe2CL3gsuMuaKR+3M/f+6oc5j9oNdrLw
kT78HWM+9TSRKl5X3rxaG6nC7ZGOI+L15cbIXDDMLh3ZTxyp0XjXtAklbvhLlyzL
5PtnOm6vhWLgnCJY+rfnTvIwgYBSXSQ67QP8BtZH0yKvj4vfAaxtI6WN6XrsvaGD
k28syPpVWMtt0UglLu3mOFeFfksUaWvFyo1YGC9jI72W8gfH1Jrtky9mLIXKKYXr
bi6mvOXG1JhT/OMC8U1SK14DmikothX0oF+YnTi3V128ZKfYIJzdc0VuxjxYR5ps
buJ2hRTM6VaniBwj2CCtNfss7MHy9CcAUE8mSgl9Ik6Wdw3zkfa9OdqFel+DGttc
eoqrd/U60AzMTbrbb7VPEmwZMHw5o5o9gwlLZcjSbX6eseWYWoAieRJRFECoq0kT
MLAY3ev6JwwxfoTe/sqD3FCXzqKVCsn1YWM8pCk8viZImGZpvIyoKz6BFvLnnjs8
fSKq2HF11ZSeqQuxEDqh
=UUOG
-----END PGP SIGNATURE-----

--cWtvayRuroyN98H5--

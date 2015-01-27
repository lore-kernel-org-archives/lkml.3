Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbbA0ALd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:11:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35299 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbbA0ALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:11:31 -0500
Date: Tue, 27 Jan 2015 00:11:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150127001122.GN21293@sirena.org.uk>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422029330-10971-17-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CV9cI//wlcIKC9rG"
Content-Disposition: inline
In-Reply-To: <1422029330-10971-17-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 16/18] spi/xilinx: Reset core before buffer_size detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CV9cI//wlcIKC9rG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 23, 2015 at 05:08:48PM +0100, Ricardo Ribalda Delgado wrote:
> If the core had some data on the buffer, the size detection could show
> up a smaller size than real, affecting performance.

This should've been part of your earlier patch.

--CV9cI//wlcIKC9rG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxteqAAoJECTWi3JdVIfQOuIH/1lzrVJ4sMZytThBjyhekw4B
22kX3qGV6+xniLUqy7wJuKyUni18ZLVa47QJT9gtIqm/YuWz+3G1oOe8YdtvJ+sI
+TultdLUIll97oKrGAV/QheWajTqIRggfqric+zveg/1Bshosu0ncdxZAYHxH5gL
xZxH7qRdMCs0ufS2hooPigiDJHkAPGxJE2lOOzYw4B2vxQUN30Ja1h/AX7CwfjBW
FKXZMTnshX8KKkZDt0RE6HLfezXdQOnb3vma23R/+ry2X46K1GTSH0ImATpouJp6
24Xd57mVJOTNOy2fpJ33dWbMyO6FMkMpdEinhIafibCFP5B7Qtz6jWjDgv9bAps=
=+dwP
-----END PGP SIGNATURE-----

--CV9cI//wlcIKC9rG--

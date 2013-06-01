Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3FASuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:50:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38877 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3FASuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:50:14 -0400
Date: Sat, 1 Jun 2013 19:49:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130601184946.GE16790@sirena.org.uk>
References: <1369931042-9755-1-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Content-Disposition: inline
In-Reply-To: <1369931042-9755-1-git-send-email-vinod.koul@intel.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regmap: give users _choice_ to allow write access to
 debugfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 30, 2013 at 09:54:01PM +0530, Vinod Koul wrote:
> is very handy is debug kernels and should _never_ be turned On in production
> mode

No, I'm not going to apply this.  Allowing users to randomly write to
devices could potentially lead to physical damage to the system and so
isn't something we want to for example see distros enabling by mistake,
and it's also a back door that people will happily use for working
around the kernel in ill conceived ways.

People who reasonably need this are edting their kernel anyway so
tweaking the in code define isn't onerous.

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqkJGAAoJELSic+t+oim92jEQAJcAr303X+i8Qv010KPybeYf
wy7oyk9ZdBfOMzl5v2p2EvtGKC5E38f0wP1n/bFk5gfJ56WmL2UOtUEGQQRb4Ayo
Xc0wclmScf7yj53rUGyGLXMslbIFnddUcYBbc8YJQ4feMj4qyusyAaI92tIQt9YH
G+EzclP18ClC5N9kkLMuhGx/JkffQ753J9zQTMd3sZQ8T6rBWI5WjbaN0cAkuK6h
MPvQ2v9bzyzuyORQrV4C0n7a9G9pR0wrEyoMqjf9R+hoLzANlgSCy4lugDRoVOdW
MBsKdfkGG7j8vAiGPXf/hyWYrSlNbmEWdYSgR6M7ODepqXE2e6eej5zi5DIG0Qvh
QW5ThfZ1dIy47KZ1ogIF1Ms1l656FM5ZMovxTzqJOb2QbmHVUxqU1A/sRBpQ4nik
p1lLtvsOBHEqWpVG4Jv6Pws9/Ovrzl330hSiSrjBEuYFZYchJbB4YbbQYOL30Lew
7OydgaaR+VKMyfav/ISmMGkKw6OuYULI3pwg23s+45+WZwE9ZjU5rpYddZ/Wlk6W
GPteVwWiKMgdvw/ap2i8oyCWvEUHY8hNUcjFnAxdHEjMitmwDe17sI1M1gbqrIk0
y37NNRIjp5jQNeMSjh6s/neZwz/bKWhoItrS59I6eFU9MKhl2SSDeMnG8SjNQIbY
kX28plum3lAip/csrhRp
=Wc2T
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--

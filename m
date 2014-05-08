Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaEHRRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:17:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38190 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaEHRRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:17:30 -0400
Date: Thu, 8 May 2014 18:17:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, arnd@arndb.de, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140508171710.GE12304@sirena.org.uk>
References: <1399565858-32480-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HqTeRtuc3QIE5maO"
Content-Disposition: inline
In-Reply-To: <1399565858-32480-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: arizona-micsupp: Add missing #include
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HqTeRtuc3QIE5maO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 05:17:38PM +0100, Charles Keepax wrote:
> of.h is presently being included through asm-generic/gpio.h so will not
> be included on some architectures, causing implicit declaration errors
> for of_get_child_by_name, of_parse_phandle and of_node_put.

Applied, thanks.

--HqTeRtuc3QIE5maO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTa7wTAAoJELSic+t+oim9+i8P/2gOhywWDkm4IZNo4Lbp1hUC
trnb+kXOcFzL3vAZzHXv/VQ1BtZXRwUPxUFo26hKs38qaPwOYxIfrerove57iLyH
uVDrVWUf316/2Xe+heyNng3bT819HKwr/I4a91ALM4HwLcOqHTDdzDN7mZ2vdmfx
CiTJwwmVattCiB8va6XLB4MBtcM0u0UH4Mx8zIeXTEdyVuP9FErKL5sTYHNAC09o
E4ZhvB68k+9dz6Mg/wtqT617ojrV4WoOLazNyGwQj2KV6MWaTZ1HTM7u7irQeFVx
FD89nz9SNNXtIS59qcmqsYS9l88o8bxHS7rZaUCW+I9NdaRdrS8TX77eMlVIyehg
FJx/AccQUudLoqFAIbipJgvZ26Fmw1K8sZ3aw+x0w1nnsZ6/lkdmiaP2ZIRB4vjn
ipc36M69lnMnbPpy96rmi1d0MphFvVZtdCoT4Hdb9tUaiameXunM5w+LXQjddXXo
BNT+vLmUI0s5XViHjAhLM3n3z0wzj8D+IuHiSRzHVKmIFcQ0Rh3LT6u3oh3eE/7O
vtPHTC0ZTvlADAuEzja+ZNjojYRDK0uzsOo9vn1sGDNpSan1BB2VnTrFSEl7Wwwj
Bv56RviFNMTXIyFI19l3WbaW6lN4w15HHOUuXOyE7/vF0TiXptIpyapmDZDT841O
cL2rIKOZnmbR0oCorXfP
=WlLL
-----END PGP SIGNATURE-----

--HqTeRtuc3QIE5maO--

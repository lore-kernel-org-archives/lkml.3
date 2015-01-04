Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbbADTXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:23:21 -0500
Received: from mail.kernel.org ([198.145.29.136]:45741 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbbADTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:23:20 -0500
Date: Sun, 4 Jan 2015 20:23:07 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hsi: nokia-modem: fix uninitialized device pointer
Message-ID: <20150104192306.GA31309@earth.universe>
References: <1420392853-5242-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1420392853-5242-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Aaro,

On Sun, Jan 04, 2015 at 07:34:13PM +0200, Aaro Koskinen wrote:
> modem->device was never initialized. This resulted in logs such as:
> [  241.386322] (NULL device *): CMT rst line change detected

Thanks, applied to for-next:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=for-next&id=67e9a2ce6e070b1e5db2dfe9c61890fc30ae954d

-- Sebastian

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUqZMXAAoJENju1/PIO/qaWloP+wV8O74KZKCHpKychtKHSxyA
9MWbhSOxjKKi2rvlIp5A1bAo1stH9YqQJVkv6rp7V5mUrdNagZ/Ffe5S12impd57
Ty70dB9uFWXykfd0cgMhoVb7ro8jCotNGQmttQ3F/yEVoQC2Lky5A59nkrj913EW
9pMIiHJe0qgHSVPUx2MDW9X8py8k11+T6JiiOedYLWUDASPOEpGfdM8wrV7L1APk
xa6SQBbe337GfbTQxkeU67+FPUEijKrsqipIswswzTsmFhq9/wdbucODKKhKfl+c
y+yPc2T8eT+xzBoRqZTa64bFyQVsjIe3AR5FuOtpUQW4i6x/RX/bjEQGZhO6NhnU
HmoICWg5yO3Bp+za8NQa4MvixLgajdd3MkTu3xH5EwBLhfnww/FexY44uJu6Zg0e
0Au9fvVrHYdHC5VqQ9AOwJElK0E35FvGLa9hTEt1N1MqMcHOloXx2VoUjfK5GOdW
ccoKygNV5c+DPCn5F7IyePNgTM1qO0w2isLLcbYU+MH0X+7mUcygHfJtkvqgKGQ6
125au64sGg6q8UXFW0lzUvKn2zvElwhkUEHmTTZhJjak5UWuJcWvb3NSDd5KHG03
p4iMX0F50oRZraBXQdbePCNKFluy4l/TA3Q++d3tQcs58wMaVjo2UERFzP0cyjaM
DJwvNYrdO/0gUdXdAUh/
=9i5r
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

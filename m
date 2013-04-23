Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3DWP4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:56:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46802 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715Ab3DWP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:56:34 -0400
Date: Tue, 23 Apr 2013 16:56:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] ASoC: don't call of_dma_request_slave_channel directly
Message-ID: <20130423155629.GS5019@opensource.wolfsonmicro.com>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
 <1366732475-479886-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjXtncIm5b3tWrFJ"
Content-Disposition: inline
In-Reply-To: <1366732475-479886-3-git-send-email-arnd@arndb.de>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qjXtncIm5b3tWrFJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 23, 2013 at 05:54:33PM +0200, Arnd Bergmann wrote:
> The exported interface for device drivers is dma_request_slave_channel,
> not of_dma_request_slave_channel. The former does not depend on device
> tree but also works with ACPI and other interfaces providing an
> abstraction for DMA channels.

> This fixes link errors when building ALSA as a loadable module.

This has already been changed separately, I'm surprised this applies
against current code.  Though one does have to wonder why it's in the
header file if it's not a supported API...

--qjXtncIm5b3tWrFJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdq8GAAoJELSic+t+oim9ZrIP/3mwT42y+29d8cL1uzv+PGLw
kBXVYWLeNg7akk9e3QCTxNCidIAodP89W24Qor5Ljz81dMEAg8Bp0Qm/lR784V6A
HlJnKTcrYnNIN3VJ5CmXhQwlYltNXf0fD/UQUVQRMSh/4a3GmXnT6t7mBM0/mjy8
G3JbSZT+mP74z2ctTHymnwQik9WXoEewA6+KLP5wDJ5dzjgcyKZzAvX2YdGkQ78/
m7gHM7Di/dzASPmFr7ICPHp62nwqoJ29UBBHOMLy0/TiGi5yCIL/JJ1kGUJBNXZ4
UwKBYxturMKNXVmVBwealhOTDP21Z3UN2v6JM0pUJtT8hEjjMpGUq2P+CFDFrgP0
S9CHKiTRCToqokEarFMhJYUGu4fp0z7w2lgNsExdwqYVT2mTCumHiof0eoLgj0YG
Cx2zCtfAnsBcNl8jt15z5QaZUQRj2M4hzs+8a/GzKXAAkdgZWUPdjEiQbFbClHdV
Rqo8iayk148QnCanW2oFV+A2U9FVY95Tfz2wilbVmnJsKB1qjtSIaiDQOMO90r7D
xuCoGI6+Wp0rqFuaVWB+MX4ZVXCUDms0rNgvgeklCkE7bIMY/kv+jUG8cfe+5TO2
XL/3RNu5sHS5OUn5464pDmnq+9WEI6N+Vo3gxWGN/3YvRTbesu8WC7NsthgvO2sC
kH9gGmxQKmVCyMh232Ho
=NHEN
-----END PGP SIGNATURE-----

--qjXtncIm5b3tWrFJ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab3CZOMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:12:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47199 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758312Ab3CZOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:12:40 -0400
Date: Tue, 26 Mar 2013 14:12:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: soc: Use PTR_RET function
Message-ID: <20130326141238.GZ18316@opensource.wolfsonmicro.com>
References: <1364222039-6829-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HENu/cXyPKFN4XCQ"
Content-Disposition: inline
In-Reply-To: <1364222039-6829-1-git-send-email-gheorghiuandru@gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HENu/cXyPKFN4XCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 25, 2013 at 04:33:59PM +0200, Alexandru Gheorghiu wrote:
> Used PTR_RET function instead of IS_ERR and PTR_ERR.
> Patch found using coccinelle.

Applied, thanks.  Please use subject lines matching the subsystem.

--HENu/cXyPKFN4XCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUazPAAoJELSic+t+oim9ln4QAIw9x8+a8uTHpyrqR0QUXO0S
AK5DRjdMIXxCQVqOgHNY7Jb5Y7QLPys/bwbV21f1hBIoYAAZ3LbjU2sGo3RIAi0y
epX95db7sfu7Dt8lSIG9/phWFMw4re3Lo7shdpSzmku9HYIZCx/GrA7WbyDplFza
/19vF/CSpGOx2TEA9vf/BayqDEOdsKanRNFz4DjYH40IyzpEryPkvFHjBe7yR0pW
568SXb7gbF58F04YvEhpuXMf8jO8Bgfv0/VcBKV76PzIEmaI8z72mebH/4QKAyEA
L3TOBPh8uABFjeb67BGTwpvcTw6ELyuwHxw9gGr/TG35fE3Y+Mp0XxfAuAaOB6np
+eF1t949YS9WzJ2Xiubn53Q4HqMeMKY+D9b083YKb1cJ6b1EPrPhgiIGHqdokNZw
A+NxrySQ5ZssE+JSZlafORU5aOp9AOsxMED6Qq9IKAgodKWUtHr0dqzrl3O3ZYNT
AfrxCQw8LgbbXmrAVpnDEUoeMyqf1jrSWp4j9/llxBVOVZVCB48a1+D7cMlSTCd4
SXK/h4EuMYzOfkQVG3SiJP/AVQaU74wl17HjODKHyJQYHNnGFVmVTihlAxAE2FZh
ONwzGzYVJVIMi9FJtCFgFnpil7Gbki+wpTgaMEHKVOE2SexFddrZEwSjhCDtiY3e
O5+fMlIMsgstiDC+/seC
=lz7U
-----END PGP SIGNATURE-----

--HENu/cXyPKFN4XCQ--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbbANTDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:03:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57395 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbANTDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:03:02 -0500
Date: Wed, 14 Jan 2015 19:02:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: ckeepax@opensource.wolfsonmicro.com, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20150114190251.GC3043@sirena.org.uk>
References: <1421143531-6662-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <1421143531-6662-1-git-send-email-voice.shen@atmel.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: wm8904: fix runtime warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2015 at 06:05:31PM +0800, Bo Shen wrote:
> Correct the path name for mux to get rid of the following warning:

Applied, thanks.

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtr1aAAoJECTWi3JdVIfQJx0H/AtAsVpVtA3+q98tTlX0DWsj
H/BeQ+0wzox/m66YL2JA5zg55SprZv1Ca8pdFyu6ZDt+jZ9vDtU4VoXpuExULy7T
yWNBI4XG9z2h/j/XfjW98EOkS06F36JPNxWoFhExuXROvPu03/+T2hWujKhnAquO
VritK+YgopvpG2uhjazAhoGj2+NK4BEWD9rqqCIwTdbB3481KMa+ftoNvQEWmP+E
FFKQHrCLUXD4FjVheapX+0GqjhQQcoZnQDRvBQ22QdByNjqX78K5CuIZtDurn3ty
CN6spTkOujJu6oTRfCGhpfgKYXfqO0FpmSS46sTkk5yLFWePv+uv4PmLVifCVLE=
=UM3h
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--

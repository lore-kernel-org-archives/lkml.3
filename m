Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaG2MEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:04:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60983 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaG2MEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:04:30 -0400
Date: Tue, 29 Jul 2014 13:04:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: alsa-devel@alsa-project.org, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, linux-kernel@vger.kernel.org
Message-ID: <20140729120406.GQ17528@sirena.org.uk>
References: <d30e88a9fa8c0e52acb48755a1b6dbd2b9e4bacf.1406629932.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJIW2pRtnvuncvpR"
Content-Disposition: inline
In-Reply-To: <d30e88a9fa8c0e52acb48755a1b6dbd2b9e4bacf.1406629932.git.shengjiu.wang@freescale.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: cs42xx8: Add SND_SOC_DAIFMT_DSP_A support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJIW2pRtnvuncvpR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 29, 2014 at 06:39:37PM +0800, Shengjiu Wang wrote:
> According to the spec, the definition of TDM and ONELINE_24 for
> CS42XX8_INTF_DAC and CS42XX8_INTF_ADC is wrong. correct them and enable
> SND_SOC_DAIFMT_DSP_A support.

Applied, thanks.

--uJIW2pRtnvuncvpR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT142zAAoJELSic+t+oim97/IQAIodZt4qnzpEYc7VoBD9do/y
pEYNWMMEPxfRriQ/VkdYC8O+DerHoH+VDxQe29v+ZEHS63RiIDoxzFMStEXn0q+p
aq6uDXkxJLe2Oa/GxCJc7HMBDoy3duhsSZ5XzsWk97cCp/BOCU57hk64vvm0urp0
PqGFy4cZZmZdhpvLafd3FsHZRJ6nNfdfm/Ia6LUTv0FcMGMTuBxGy4RlbWNAaHXw
RS/X5j9oxLvFAk0SL3kJr4RmSWc4QfP1pHwv4CHX8Ik1WXQsBNNw9s2uA+8aYxdG
f5oQB0Ep+2TdwS5ZP5t58XgCgQzgcOShwNFN3vdgLj8yqANmp33SfksI44DHuDG1
ogP/LWpcoDC48KOFanSqOLh5SXu6ci7sLqHkx6cHh+CBeo2xZeElJXwjhHoofsAB
tHBL8DaqoLabC7tRvWa3kH1CrpeOXNwvIt8fzR6gBIL5AID7budb34VF0zUq0HZ8
MRmUbpErjvPE7IdcbVLS54XOK2DuNevyblm+qp+hh2yathqz98Ymk2Lq0jyqrxng
FTKjEeIK86TtHijwpY2DtYgBBs0OYafgss05keDI70FCmVcrQSEpkhxyX6CP08BI
zenIn3+pwF3ANyVy1eq6O2Sy1d4gv02z9c3Hy1gFFsyu+5GUTrit2AvyCcUSSaVX
J3V+HwFH96d11vkZ3s24
=2IYL
-----END PGP SIGNATURE-----

--uJIW2pRtnvuncvpR--

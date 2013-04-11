Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab3DKRNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:13:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43152 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112Ab3DKRNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:13:18 -0400
Date: Thu, 11 Apr 2013 18:13:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lgirdwood@intel.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ASoC updates for v3.9-rc6
Message-ID: <20130411171316.GR9243@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2+Swrz5l75R1PXkU"
Content-Disposition: inline
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2+Swrz5l75R1PXkU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git tags/asoc-v3.9-rc6

for you to fetch changes up to ca62bed0bbf9baf88d8bb404d72dee3b44ef057e:

  Merge remote-tracking branch 'asoc/fix/wm8903' into tmp (2013-04-11 18:00:31 +0100)

----------------------------------------------------------------

ASoC: Updates for v3.9

A few updates, more than I'd like, fixing some relatively small issues
but mostly driver specific ones.  Nothing wildly exciting so if it
doesn't make v3.9 it won't be the end of the world but it'd be nice.

----------------------------------------------------------------
Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running

Charles Keepax (1):
      ASoC: compress: Cancel delayed power down if needed

Joonyoung Shim (1):
      ASoC: core: Fix to check return value of snd_soc_update_bits_locked()

Lars-Peter Clausen (1):
      ASoC: tegra: Don't claim to support PCM pause and resume

Mark Brown (6):
      ASoC: wm5102: Correct lookup of arizona struct in SYSCLK event
      Merge remote-tracking branch 'asoc/fix/compress' into tmp
      Merge remote-tracking branch 'asoc/fix/core' into tmp
      Merge remote-tracking branch 'asoc/fix/samsung' into tmp
      Merge remote-tracking branch 'asoc/fix/tegra' into tmp
      Merge remote-tracking branch 'asoc/fix/wm8903' into tmp

Prathyush K (2):
      ASoC: Samsung: return error if drvdata is not set
      ASoC: Samsung: set drvdata before adding secondary device

 sound/soc/codecs/wm5102.c   |    2 +-
 sound/soc/codecs/wm8903.c   |    2 ++
 sound/soc/samsung/i2s.c     |   17 ++++++++++++-----
 sound/soc/soc-compress.c    |   14 +++++++++++---
 sound/soc/soc-core.c        |    2 +-
 sound/soc/tegra/tegra_pcm.c |   24 +-----------------------
 6 files changed, 28 insertions(+), 33 deletions(-)

--2+Swrz5l75R1PXkU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZu8iAAoJELSic+t+oim9zV8P/1go8MlEIZaC/8Vc9n87Jq8+
VOMQCTfCuCyPCuNLfVZxvDsJW4A0pe46VA8XPgnKixa/JZ7Ps57YQqWXMqfMY0i3
EEMQUGKJVPbFfHkrrq8lMYeQj3UX+k9qw/gJOkwZAhFz8qgQZ4Dy6ZB55k8RKXeT
PoXpzEYiA50q42h+BTkZzYVEQfsIAMwi01RJQAKeqFkUvxf3ZH3HhuABo8sp71EV
0pOUOp7Hn0uLz+EuQ3UVR6uvfXjTehrXRflcDjbgwSsCavKI60qxgVLHVTXfcZ/9
Q5konjrgqh1vekpOdVGGlFAF8ytu8c/14aJ2l5HASWrKPO0SBZC4D2ENsqPNBB5P
0AXbG9qPr/GLPgpRXlofpCc+IHPA5c5Pwa0VJAm06iMRMyULFwmAgp/CRL5y2952
nlOreFCdAMbQ2OCdwIjIFLLyq111E2Gk5h4sWlFySUR9kUzY/LYBf3fyMn9mRlRM
dNEWTdFwVe/F4L1BOX90Sk+gBW1i2CAN4ovFBWdbzkTId6LSmViyCSJHI1rBtTW+
WRk7Uqzt7l9GjpnRpm+/dI3FwqMwPebAQqzX4GoBlvTKl7M6Km67Sns87jUPpWMb
ArQmAXqMbKTQwHb6iiJB2JiFQJBXZ/eWdvzXlpD6jmY5JqM+6aBJCsC0awWjZxrF
iEe/H1k817MrXlvIUXpE
=9lR2
-----END PGP SIGNATURE-----

--2+Swrz5l75R1PXkU--

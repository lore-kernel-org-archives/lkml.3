Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3JHWzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 18:55:52 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:37910 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755341Ab3JHWzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 18:55:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3868:4050:4118:4321:4605:5007:7652:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12688:12737:13019:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: watch97_89d1e963a4812
X-Filterd-Recvd-Size: 7948
Message-ID: <1381272945.23937.2.camel@joe-AO722>
Subject: [Trivial PATCH] sound: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 15:55:45 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These aren't necessary after switch and if blocks.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/oss/sb_ess.c              | 2 +-
 sound/pci/au88x0/au88x0_pcm.c   | 2 +-
 sound/soc/atmel/atmel_ssc_dai.c | 2 +-
 sound/soc/codecs/ak4641.c       | 2 +-
 sound/soc/codecs/mc13783.c      | 2 +-
 sound/soc/codecs/tas5086.c      | 2 +-
 sound/soc/codecs/twl6040.c      | 4 ++--
 sound/soc/fsl/fsl_spdif.c       | 4 ++--
 sound/soc/tegra/tegra20_i2s.c   | 6 +++---
 sound/soc/tegra/tegra20_spdif.c | 6 +++---
 sound/soc/tegra/tegra30_ahub.c  | 4 ++--
 sound/soc/tegra/tegra30_i2s.c   | 4 ++--
 12 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/sound/oss/sb_ess.c b/sound/oss/sb_ess.c
index c0be085..0e7254b 100644
--- a/sound/oss/sb_ess.c
+++ b/sound/oss/sb_ess.c
@@ -1544,7 +1544,7 @@ static int ess_has_rec_mixer (int submodel)
 		return 1;
 	default:
 		return 0;
-	};
+	}
 };
 
 #ifdef FKS_LOGGING
diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index b46dc9b..9fb03b4 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -671,7 +671,7 @@ static int snd_vortex_new_pcm(vortex_t *chip, int idx, int nr)
 			return err;
 		break;
 #endif
-	};
+	}
 
 	if (VORTEX_PCM_TYPE(pcm) == VORTEX_PCM_SPDIF) {
 		for (i = 0; i < ARRAY_SIZE(snd_vortex_mixer_spdif); i++) {
diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index bb53dea..8697ced 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -777,7 +777,7 @@ static int asoc_ssc_init(struct device *dev)
 	if (ret) {
 		dev_err(dev, "Could not register PCM: %d\n", ret);
 		goto err_unregister_dai;
-	};
+	}
 
 	return 0;
 
diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
index 5f9af1f..49cc5f6 100644
--- a/sound/soc/codecs/ak4641.c
+++ b/sound/soc/codecs/ak4641.c
@@ -328,7 +328,7 @@ static int ak4641_i2s_hw_params(struct snd_pcm_substream *substream,
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		ak4641->playback_fs = rate;
 		ak4641_set_deemph(codec);
-	};
+	}
 
 	return 0;
 }
diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index ea141e1..1544330 100644
--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -382,7 +382,7 @@ static int mc13783_set_tdm_slot_dac(struct snd_soc_dai *dai,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	snd_soc_update_bits(codec, MC13783_SSI_NETWORK, mask, val);
 
diff --git a/sound/soc/codecs/tas5086.c b/sound/soc/codecs/tas5086.c
index 6d31d88..e29cdb7 100644
--- a/sound/soc/codecs/tas5086.c
+++ b/sound/soc/codecs/tas5086.c
@@ -429,7 +429,7 @@ static int tas5086_hw_params(struct snd_pcm_substream *substream,
 	default:
 		dev_err(codec->dev, "Invalid bit width\n");
 		return -EINVAL;
-	};
+	}
 
 	ret = regmap_write(priv->regmap, TAS5086_SERIAL_DATA_IF, val);
 	if (ret < 0)
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 3c79dbb..35059a2 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -246,7 +246,7 @@ static bool twl6040_is_path_unmuted(struct snd_soc_codec *codec,
 		return priv->dl2_unmuted;
 	default:
 		return 1;
-	};
+	}
 }
 
 /*
@@ -1100,7 +1100,7 @@ static void twl6040_mute_path(struct snd_soc_codec *codec, enum twl6040_dai_id i
 		break;
 	default:
 		break;
-	};
+	}
 }
 
 static int twl6040_digital_mute(struct snd_soc_dai *dai, int mute)
diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 3920c3e..c0fea02 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -963,7 +963,7 @@ static bool fsl_spdif_readable_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static bool fsl_spdif_writeable_reg(struct device *dev, unsigned int reg)
@@ -982,7 +982,7 @@ static bool fsl_spdif_writeable_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static const struct regmap_config fsl_spdif_regmap_config = {
diff --git a/sound/soc/tegra/tegra20_i2s.c b/sound/soc/tegra/tegra20_i2s.c
index 52af7f6..364bf6a 100644
--- a/sound/soc/tegra/tegra20_i2s.c
+++ b/sound/soc/tegra/tegra20_i2s.c
@@ -297,7 +297,7 @@ static bool tegra20_i2s_wr_rd_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static bool tegra20_i2s_volatile_reg(struct device *dev, unsigned int reg)
@@ -310,7 +310,7 @@ static bool tegra20_i2s_volatile_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static bool tegra20_i2s_precious_reg(struct device *dev, unsigned int reg)
@@ -321,7 +321,7 @@ static bool tegra20_i2s_precious_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static const struct regmap_config tegra20_i2s_regmap_config = {
diff --git a/sound/soc/tegra/tegra20_spdif.c b/sound/soc/tegra/tegra20_spdif.c
index 551b3c9..08bc693 100644
--- a/sound/soc/tegra/tegra20_spdif.c
+++ b/sound/soc/tegra/tegra20_spdif.c
@@ -213,7 +213,7 @@ static bool tegra20_spdif_wr_rd_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static bool tegra20_spdif_volatile_reg(struct device *dev, unsigned int reg)
@@ -234,7 +234,7 @@ static bool tegra20_spdif_volatile_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static bool tegra20_spdif_precious_reg(struct device *dev, unsigned int reg)
@@ -247,7 +247,7 @@ static bool tegra20_spdif_precious_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static const struct regmap_config tegra20_spdif_regmap_config = {
diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index d554d46..805b1f3 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -346,7 +346,7 @@ static bool tegra30_ahub_apbif_wr_rd_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		break;
-	};
+	}
 
 	if (REG_IN_ARRAY(reg, CHANNEL_CTRL) ||
 	    REG_IN_ARRAY(reg, CHANNEL_CLEAR) ||
@@ -381,7 +381,7 @@ static bool tegra30_ahub_apbif_volatile_reg(struct device *dev,
 		return true;
 	default:
 		break;
-	};
+	}
 
 	if (REG_IN_ARRAY(reg, CHANNEL_CLEAR) ||
 	    REG_IN_ARRAY(reg, CHANNEL_STATUS) ||
diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index 47565fd04..bd71145 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -369,7 +369,7 @@ static bool tegra30_i2s_wr_rd_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static bool tegra30_i2s_volatile_reg(struct device *dev, unsigned int reg)
@@ -382,7 +382,7 @@ static bool tegra30_i2s_volatile_reg(struct device *dev, unsigned int reg)
 		return true;
 	default:
 		return false;
-	};
+	}
 }
 
 static const struct regmap_config tegra30_i2s_regmap_config = {




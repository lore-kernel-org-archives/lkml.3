Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3JHX3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:29:13 -0400
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:58062 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755341Ab3JHX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:29:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3867:3868:3871:4051:4119:4321:4605:5007:6119:7652:7903:8603:10004:10848:11026:11473:11657:11658:11914:12043:12217:12296:12438:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: uncle62_8a429248e6808
X-Filterd-Recvd-Size: 8744
Message-ID: <1381274948.23937.17.camel@joe-AO722>
Subject: [Trivial PATCH] media: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 16:29:08 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These aren't necessary after switch and while statements.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/common/b2c2/flexcop-sram.c         | 6 +++---
 drivers/media/dvb-frontends/cx24110.c            | 2 +-
 drivers/media/dvb-frontends/cx24123.c            | 2 +-
 drivers/media/dvb-frontends/tda8083.c            | 4 ++--
 drivers/media/i2c/soc_camera/ov9640.c            | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c     | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c  | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c  | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c  | 2 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c  | 2 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c   | 2 +-
 drivers/media/radio/si470x/radio-si470x-common.c | 2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c             | 2 +-
 13 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-sram.c b/drivers/media/common/b2c2/flexcop-sram.c
index f2199e4..185c285 100644
--- a/drivers/media/common/b2c2/flexcop-sram.c
+++ b/drivers/media/common/b2c2/flexcop-sram.c
@@ -85,7 +85,7 @@ static void flexcop_sram_write(struct adapter *adapter, u32 bank, u32 addr, u8 *
 		while (((read_reg_dw(adapter, 0x700) & 0x80000000) != 0) && (retries > 0)) {
 			mdelay(1);
 			retries--;
-		};
+		}
 
 		if (retries == 0)
 			printk("%s: SRAM timeout\n", __func__);
@@ -110,7 +110,7 @@ static void flex_sram_read(struct adapter *adapter, u32 bank, u32 addr, u8 *buf,
 		while (((read_reg_dw(adapter, 0x700) & 0x80000000) != 0) && (retries > 0)) {
 			mdelay(1);
 			retries--;
-		};
+		}
 
 		if (retries == 0)
 			printk("%s: SRAM timeout\n", __func__);
@@ -122,7 +122,7 @@ static void flex_sram_read(struct adapter *adapter, u32 bank, u32 addr, u8 *buf,
 		while (((read_reg_dw(adapter, 0x700) & 0x80000000) != 0) && (retries > 0)) {
 			mdelay(1);
 			retries--;
-		};
+		}
 
 		if (retries == 0)
 			printk("%s: SRAM timeout\n", __func__);
diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 0cd6927..95b981c 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -378,7 +378,7 @@ static int cx24110_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t voltag
 		return cx24110_writereg(state,0x76,(cx24110_readreg(state,0x76)&0x3b)|0x40);
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static int cx24110_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_cmd_t burst)
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index a771da3..72fb583 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -739,7 +739,7 @@ static int cx24123_set_voltage(struct dvb_frontend *fe,
 		return 0;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
index 9d08350..69e62f4 100644
--- a/drivers/media/dvb-frontends/tda8083.c
+++ b/drivers/media/dvb-frontends/tda8083.c
@@ -189,7 +189,7 @@ static int tda8083_set_tone (struct tda8083_state* state, fe_sec_tone_mode_t ton
 		return tda8083_writereg (state, 0x29, 0x80);
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static int tda8083_set_voltage (struct tda8083_state* state, fe_sec_voltage_t voltage)
@@ -201,7 +201,7 @@ static int tda8083_set_voltage (struct tda8083_state* state, fe_sec_voltage_t vo
 		return tda8083_writereg (state, 0x20, 0x11);
 	default:
 		return -EINVAL;
-	};
+	}
 }
 
 static int tda8083_send_diseqc_burst (struct tda8083_state* state, fe_sec_mini_cmd_t burst)
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index e968c3f..bc74224 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -371,7 +371,7 @@ static void ov9640_alter_regs(enum v4l2_mbus_pixelcode code,
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_565;
 		break;
-	};
+	}
 }
 
 /* Setup registers according to resolution and color encoding */
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index d2e6cba..f3c6136 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -511,7 +511,7 @@ static int __ctrl_set_metering(struct fimc_is *is, unsigned int value)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	__is_set_isp_metering(is, IS_METERING_CONFIG_CMD, val);
 	return 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
index ad4f1df..9a6efd6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
@@ -111,7 +111,7 @@ static int s5p_mfc_open_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
 		break;
 	default:
 		h2r_args.arg[0] = S5P_FIMV_CODEC_NONE;
-	};
+	}
 	h2r_args.arg[1] = 0; /* no crc & no pixelcache */
 	h2r_args.arg[2] = ctx->ctx.ofs;
 	h2r_args.arg[3] = ctx->ctx.size;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
index db796c8..ec1a594 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -113,7 +113,7 @@ static int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	default:
 		codec_type = S5P_FIMV_CODEC_NONE_V6;
-	};
+	}
 	mfc_write(dev, codec_type, S5P_FIMV_CODEC_TYPE_V6);
 	mfc_write(dev, ctx->ctx.dma, S5P_FIMV_CONTEXT_MEM_ADDR_V6);
 	mfc_write(dev, ctx->ctx.size, S5P_FIMV_CONTEXT_MEM_SIZE_V6);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 368582b..58ec7bb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1582,7 +1582,7 @@ static int s5p_mfc_get_int_reason_v5(struct s5p_mfc_dev *dev)
 		break;
 	default:
 		reason = S5P_MFC_R2H_CMD_EMPTY;
-	};
+	}
 	return reason;
 }
 
diff --git a/drivers/media/platform/s5p-tv/mixer_grp_layer.c b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
index b93a21f..74344c7 100644
--- a/drivers/media/platform/s5p-tv/mixer_grp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_grp_layer.c
@@ -226,7 +226,7 @@ static void mxr_graph_fix_geometry(struct mxr_layer *layer,
 			src->width + src->x_offset, 32767);
 		src->full_height = clamp_val(src->full_height,
 			src->height + src->y_offset, 2047);
-	};
+	}
 }
 
 /* PUBLIC API */
diff --git a/drivers/media/platform/s5p-tv/mixer_vp_layer.c b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
index 3d13a63..c9388c4 100644
--- a/drivers/media/platform/s5p-tv/mixer_vp_layer.c
+++ b/drivers/media/platform/s5p-tv/mixer_vp_layer.c
@@ -197,7 +197,7 @@ static void mxr_vp_fix_geometry(struct mxr_layer *layer,
 			ALIGN(src->width + src->x_offset, 8), 8192U);
 		src->full_height = clamp(src->full_height,
 			src->height + src->y_offset, 8192U);
-	};
+	}
 }
 
 /* PUBLIC API */
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 5c57e5b..4a7a1cc 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -254,7 +254,7 @@ static unsigned int si470x_get_step(struct si470x_device *radio)
 	/* 2:  50 kHz */
 	default:
 		return 50 * 16;
-	};
+	}
 }
 
 
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index c3f0803..df3a67b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -583,7 +583,7 @@ const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
 	default:
 		*len = 0;
 		return NULL;
-	};
+	}
 }
 EXPORT_SYMBOL(v4l2_ctrl_get_int_menu);
 



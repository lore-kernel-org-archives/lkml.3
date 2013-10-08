Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3JHXXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:23:30 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:51607 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755341Ab3JHXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:23:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:355:379:541:800:857:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1461:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:1801:2393:2559:2562:2828:2898:2914:3138:3139:3140:3141:3142:3865:3867:3868:3870:3871:4051:4120:4250:4321:4384:4605:5007:6119:7652:7904:8879:8957:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12731:12737:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bait40_582b5708e204e
X-Filterd-Recvd-Size: 9299
Message-ID: <1381274604.23937.15.camel@joe-AO722>
Subject: [Trivial PATCH] video: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 Oct 2013 16:23:24 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These aren't necessary after switch, for, and if blocks.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/cfbimgblt.c                       | 2 +-
 drivers/video/cg14.c                            | 4 ++--
 drivers/video/cg6.c                             | 2 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c   | 2 +-
 drivers/video/fsl-diu-fb.c                      | 2 +-
 drivers/video/leo.c                             | 2 +-
 drivers/video/matrox/matroxfb_DAC1064.c         | 4 ++--
 drivers/video/matrox/matroxfb_Ti3026.c          | 2 +-
 drivers/video/nvidia/nv_hw.c                    | 2 +-
 drivers/video/omap2/displays-new/panel-dsi-cm.c | 2 +-
 drivers/video/omap2/dss/dispc.c                 | 2 +-
 drivers/video/omap2/dss/dsi.c                   | 2 +-
 drivers/video/sbuslib.c                         | 2 +-
 drivers/video/sysimgblt.c                       | 2 +-
 drivers/video/tcx.c                             | 4 ++--
 drivers/video/vt8500lcdfb.c                     | 2 +-
 16 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/video/cfbimgblt.c b/drivers/video/cfbimgblt.c
index baed57d..a2bb276 100644
--- a/drivers/video/cfbimgblt.c
+++ b/drivers/video/cfbimgblt.c
@@ -181,7 +181,7 @@ static inline void slow_imageblit(const struct fb_image *image, struct fb_info *
 			}
 			shift += bpp;
 			shift &= (32 - 1);
-			if (!l) { l = 8; s++; };
+			if (!l) { l = 8; s++; }
 		}
 
 		/* write trailing bits */
diff --git a/drivers/video/cg14.c b/drivers/video/cg14.c
index ed3b889..e220e69 100644
--- a/drivers/video/cg14.c
+++ b/drivers/video/cg14.c
@@ -330,7 +330,7 @@ static int cg14_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 		default:
 			ret = -ENOSYS;
 			break;
-		};
+		}
 		if (!ret) {
 			sbus_writeb(cur_mode, &regs->mcr);
 			par->mode = mode;
@@ -343,7 +343,7 @@ static int cg14_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 					  FBTYPE_MDICOLOR, 8,
 					  info->fix.smem_len);
 		break;
-	};
+	}
 
 	return ret;
 }
diff --git a/drivers/video/cg6.c b/drivers/video/cg6.c
index 3545dec..f50f61c 100644
--- a/drivers/video/cg6.c
+++ b/drivers/video/cg6.c
@@ -624,7 +624,7 @@ static void cg6_init_fix(struct fb_info *info, int linebytes)
 	default:
 		cg6_cpu_name = "i386";
 		break;
-	};
+	}
 	if (((conf >> CG6_FHC_REV_SHIFT) & CG6_FHC_REV_MASK) >= 11) {
 		if (info->fix.smem_len <= 0x100000)
 			cg6_card_name = "TGX";
diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c b/drivers/video/exynos/exynos_mipi_dsi_common.c
index 520fc9b..9b32165 100644
--- a/drivers/video/exynos/exynos_mipi_dsi_common.c
+++ b/drivers/video/exynos/exynos_mipi_dsi_common.c
@@ -667,7 +667,7 @@ int exynos_mipi_dsi_init_dsim(struct mipi_dsim_device *dsim)
 	default:
 		dev_info(dsim->dev, "data lane is invalid.\n");
 		return -EINVAL;
-	};
+	}
 
 	exynos_mipi_dsi_sw_reset(dsim);
 	exynos_mipi_dsi_func_reset(dsim);
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 6dd7225..6c71bb6 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1102,7 +1102,7 @@ static int fsl_diu_cursor(struct fb_info *info, struct fb_cursor *cursor)
 
 		fsl_diu_load_cursor_image(info, image, bg, fg,
 			cursor->image.width, cursor->image.height);
-	};
+	}
 
 	/*
 	 * Show or hide the cursor.  The cursor data is always stored in the
diff --git a/drivers/video/leo.c b/drivers/video/leo.c
index b17f500..c36f013 100644
--- a/drivers/video/leo.c
+++ b/drivers/video/leo.c
@@ -469,7 +469,7 @@ static void leo_wid_put(struct fb_info *info, struct fb_wid_list *wl)
 
 		default:
 			continue;
-		};
+		}
 		sbus_writel(0x5800 + j, &lx_krn->krn_type);
 		sbus_writel(wi->wi_values[0], &lx_krn->krn_value);
 	}
diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/matrox/matroxfb_DAC1064.c
index 1717623..a01147f 100644
--- a/drivers/video/matrox/matroxfb_DAC1064.c
+++ b/drivers/video/matrox/matroxfb_DAC1064.c
@@ -494,7 +494,7 @@ static int m1064_compute(void* out, struct my_timming* m) {
 			if (inDAC1064(minfo, M1064_XPIXPLLSTAT) & 0x40)
 				break;
 			udelay(10);
-		};
+		}
 
 		CRITEND
 
@@ -639,7 +639,7 @@ static void MGAG100_progPixClock(const struct matrox_fb_info *minfo, int flags,
 		if (inDAC1064(minfo, M1064_XPIXPLLSTAT) & 0x40)
 			break;
 		udelay(10);
-	};
+	}
 	if (!clk)
 		printk(KERN_ERR "matroxfb: Pixel PLL%c not locked after usual time\n", (reg-M1064_XPIXPLLAM-2)/4 + 'A');
 	selClk = inDAC1064(minfo, M1064_XPIXCLKCTRL) & ~M1064_XPIXCLKCTRL_SRC_MASK;
diff --git a/drivers/video/matrox/matroxfb_Ti3026.c b/drivers/video/matrox/matroxfb_Ti3026.c
index 9a44cec..195ad7c 100644
--- a/drivers/video/matrox/matroxfb_Ti3026.c
+++ b/drivers/video/matrox/matroxfb_Ti3026.c
@@ -473,7 +473,7 @@ static void ti3026_setMCLK(struct matrox_fb_info *minfo, int fout)
 		if (inTi3026(minfo, TVP3026_XPIXPLLDATA) & 0x40)
 			break;
 		udelay(10);
-	};
+	}
 	if (!tmout)
 		printk(KERN_ERR "matroxfb: Temporary pixel PLL not locked after 5 secs\n");
 
diff --git a/drivers/video/nvidia/nv_hw.c b/drivers/video/nvidia/nv_hw.c
index ed20a98..81c80ac 100644
--- a/drivers/video/nvidia/nv_hw.c
+++ b/drivers/video/nvidia/nv_hw.c
@@ -1300,7 +1300,7 @@ void NVLoadStateExt(struct nvidia_par *par, RIVA_HW_STATE * state)
 					break;
 				default:
 					break;
-				};
+				}
 
 				NV_WR32(par->PGRAPH, 0x0b38, 0x2ffff800);
 				NV_WR32(par->PGRAPH, 0x0b3c, 0x00006000);
diff --git a/drivers/video/omap2/displays-new/panel-dsi-cm.c b/drivers/video/omap2/displays-new/panel-dsi-cm.c
index aaaea64..b7baafe 100644
--- a/drivers/video/omap2/displays-new/panel-dsi-cm.c
+++ b/drivers/video/omap2/displays-new/panel-dsi-cm.c
@@ -599,7 +599,7 @@ static int dsicm_power_on(struct panel_drv_data *ddata)
 	if (r) {
 		dev_err(&ddata->pdev->dev, "failed to configure DSI pins\n");
 		goto err0;
-	};
+	}
 
 	r = in->ops.dsi->set_config(in, &dsi_config);
 	if (r) {
diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/dispc.c
index 4779750..96a1ea3 100644
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -2918,7 +2918,7 @@ static void _dispc_mgr_set_lcd_timings(enum omap_channel channel, int hsw,
 		break;
 	default:
 		BUG();
-	};
+	}
 
 	l = dispc_read_reg(DISPC_POL_FREQ(channel));
 	l |= FLD_VAL(onoff, 17, 17);
diff --git a/drivers/video/omap2/dss/dsi.c b/drivers/video/omap2/dss/dsi.c
index a598b58..b79f2aa 100644
--- a/drivers/video/omap2/dss/dsi.c
+++ b/drivers/video/omap2/dss/dsi.c
@@ -4066,7 +4066,7 @@ static int dsi_enable_video_output(struct omap_dss_device *dssdev, int channel)
 		default:
 			r = -EINVAL;
 			goto err_pix_fmt;
-		};
+		}
 
 		dsi_if_enable(dsidev, false);
 		dsi_vc_enable(dsidev, channel, false);
diff --git a/drivers/video/sbuslib.c b/drivers/video/sbuslib.c
index 296afae..a350209 100644
--- a/drivers/video/sbuslib.c
+++ b/drivers/video/sbuslib.c
@@ -186,7 +186,7 @@ int sbusfb_ioctl_helper(unsigned long cmd, unsigned long arg,
 	}
 	default:
 		return -EINVAL;
-	};
+	}
 }
 EXPORT_SYMBOL(sbusfb_ioctl_helper);
 
diff --git a/drivers/video/sysimgblt.c b/drivers/video/sysimgblt.c
index 186c6f6..a4d05b1 100644
--- a/drivers/video/sysimgblt.c
+++ b/drivers/video/sysimgblt.c
@@ -152,7 +152,7 @@ static void slow_imageblit(const struct fb_image *image, struct fb_info *p,
 			}
 			shift += bpp;
 			shift &= (32 - 1);
-			if (!l) { l = 8; s++; };
+			if (!l) { l = 8; s++; }
 		}
 
 		/* write trailing bits */
diff --git a/drivers/video/tcx.c b/drivers/video/tcx.c
index c000852..634f60e 100644
--- a/drivers/video/tcx.c
+++ b/drivers/video/tcx.c
@@ -232,7 +232,7 @@ tcx_blank(int blank, struct fb_info *info)
 
 	case FB_BLANK_POWERDOWN: /* Poweroff */
 		break;
-	};
+	}
 
 	sbus_writel(val, &thc->thc_misc);
 
@@ -434,7 +434,7 @@ static int tcx_probe(struct platform_device *op)
 		default:
 			j = i;
 			break;
-		};
+		}
 		par->mmap_map[i].poff = op->resource[j].start;
 	}
 
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 897484903..b30e5a4 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -365,7 +365,7 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
 		return -ENOMEM;
-	};
+	}
 
 	fbi->fb.fix.smem_start	= fb_mem_phys;
 	fbi->fb.fix.smem_len	= fb_mem_len;



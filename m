Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3GLG6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:58:47 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:40396 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab3GLG6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:58:46 -0400
From: Vladimir Cernov <gg.kaspersky@gmail.com>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk, chad@dahc.us,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Vladimir <gg.kaspersky@gmail.com>
Subject: [PATCH] Staging: silicom: Remove useless unneeded semicolons
Date: Fri, 12 Jul 2013 09:58:26 +0300
Message-Id: <1373612306-8313-1-git-send-email-gg.kaspersky@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir <gg.kaspersky@gmail.com>

Found using coccinelle tool.
Signed-off-by: Vladimir Cernov <gg.kaspersky@gmail.com>
---
 drivers/staging/silicom/bpctl_mod.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 48b9fb1..42d6d27 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -1809,7 +1809,7 @@ int cmnd_off(bpctl_dev_t *pbpctl_dev)
 		else
 			data_pulse(pbpctl_dev, CMND_OFF);
 		ret = 0;
-	};
+	}
 	return ret;
 }
 
@@ -1830,7 +1830,7 @@ int bypass_on(bpctl_dev_t *pbpctl_dev)
 		} else
 			data_pulse(pbpctl_dev, BYPASS_ON);
 		ret = 0;
-	};
+	}
 	return ret;
 }
 
@@ -1866,7 +1866,7 @@ int tap_off(bpctl_dev_t *pbpctl_dev)
 		write_data(pbpctl_dev, TAP_OFF);
 		msec_delay_bp(LATCH_DELAY);
 		ret = 0;
-	};
+	}
 	return ret;
 }
 
@@ -1879,7 +1879,7 @@ int tap_on(bpctl_dev_t *pbpctl_dev)
 		write_data(pbpctl_dev, TAP_ON);
 		msec_delay_bp(LATCH_DELAY);
 		ret = 0;
-	};
+	}
 	return ret;
 }
 
@@ -2025,7 +2025,7 @@ int wdt_off(bpctl_dev_t *pbpctl_dev)
 			data_pulse(pbpctl_dev, WDT_OFF);
 		pbpctl_dev->wdt_status = WDT_STATUS_DIS;
 		ret = 0;
-	};
+	}
 	return ret;
 }
 
@@ -2568,7 +2568,7 @@ int reset_cont(bpctl_dev_t *pbpctl_dev)
 		else
 			data_pulse(pbpctl_dev, RESET_CONT);
 		ret = 0;
-	};
+	}
 	return ret;
 }
 
@@ -3497,7 +3497,7 @@ int wdt_programmed(bpctl_dev_t *pbpctl_dev, int *timeout)
 				*timeout =
 				    curr_wdt_status ==
 				    0 ? 0 : pbpctl_dev->bypass_timer_interval;
-		};
+		}
 	} else
 		ret = BP_NOT_CAP;
 	return ret;
@@ -3548,7 +3548,7 @@ int normal_support(bpctl_dev_t *pbpctl_dev)
 			      NORMAL_UNSUPPORT_MASK) ? 0 : 1);
 		} else
 			ret = 1;
-	};
+	}
 	return ret;
 }
 
@@ -5111,7 +5111,7 @@ int set_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev, unsigned int param)
 			pbpctl_dev->bp_tpl_flag = param;
 			mod_timer(&pbpctl_dev->bp_tpl_timer, jiffies + 1);
 			return BP_OK;
-		};
+		}
 		if ((!param) && (pbpctl_dev->bp_tpl_flag))
 			remove_bypass_tpl_auto(pbpctl_dev);
 
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaGCLUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:20:21 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:34772 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGCLUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:20:14 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 07:20:12 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <2fd968819dec3f46412f4f9798adc582>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: mark yao <mark.yao@rock-chips.com>
To: heiko@sntech.de, airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, cym@rock-chips.com, kfx@rock-chips.com,
        xjq@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, xw@rock-chips.com,
        mark <mark.yao@rock-chips.com>
Subject: [PATCH] drm: Add Drm driver for Rockchip Socs
Date: Thu,  3 Jul 2014 19:08:13 +0800
Message-Id: <1404385693-27388-2-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404385693-27388-1-git-send-email-mark.yao@rock-chips.com>
References: <1404385693-27388-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mark <mark.yao@rock-chips.com>

This patch is a DRM Driver for Rockchip Socs and now only add the
framework of Rockchips Socs, but we will add Rockchips Socs soon.

Signed-off-by: mark <mark.yao@rock-chips.com>
---
 drivers/gpu/drm/Kconfig                           |    2 +
 drivers/gpu/drm/Makefile                          |    1 +
 drivers/gpu/drm/rockchip/Kconfig                  |   35 +
 drivers/gpu/drm/rockchip/Makefile                 |   14 +
 drivers/gpu/drm/rockchip/rockchip_drm_buf.c       |  191 ++++++
 drivers/gpu/drm/rockchip/rockchip_drm_buf.h       |   39 ++
 drivers/gpu/drm/rockchip/rockchip_drm_connector.c |  261 ++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_connector.h |   24 +
 drivers/gpu/drm/rockchip/rockchip_drm_core.c      |  163 +++++
 drivers/gpu/drm/rockchip/rockchip_drm_crtc.c      |  515 ++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_crtc.h      |   42 ++
 drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.c    |  290 ++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.h    |   32 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c       |  618 +++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h       |  319 +++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_encoder.c   |  206 ++++++
 drivers/gpu/drm/rockchip/rockchip_drm_encoder.h   |   30 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c        |  333 ++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_fb.h        |   39 ++
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c     |  380 +++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h     |   26 +
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c       |  738 +++++++++++++++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h       |  198 ++++++
 drivers/gpu/drm/rockchip/rockchip_drm_iommu.c     |  149 +++++
 drivers/gpu/drm/rockchip/rockchip_drm_iommu.h     |   76 +++
 drivers/gpu/drm/rockchip/rockchip_drm_plane.c     |  290 ++++++++
 drivers/gpu/drm/rockchip/rockchip_drm_plane.h     |   30 +
 include/uapi/drm/rockchip_drm.h                   |  155 +++++
 28 files changed, 5196 insertions(+)
 create mode 100644 drivers/gpu/drm/rockchip/Kconfig
 create mode 100644 drivers/gpu/drm/rockchip/Makefile
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_buf.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_buf.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_connector.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_connector.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_core.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_crtc.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_crtc.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_encoder.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_encoder.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_iommu.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_iommu.h
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_plane.c
 create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_plane.h
 create mode 100644 include/uapi/drm/rockchip_drm.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index f512004..5951c2c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -170,6 +170,8 @@ config DRM_SAVAGE
 
 source "drivers/gpu/drm/exynos/Kconfig"
 
+source "drivers/gpu/drm/rockchip/Kconfig"
+
 source "drivers/gpu/drm/vmwgfx/Kconfig"
 
 source "drivers/gpu/drm/gma500/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index dd2ba42..40babd2 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_DRM_VMWGFX)+= vmwgfx/
 obj-$(CONFIG_DRM_VIA)	+=via/
 obj-$(CONFIG_DRM_NOUVEAU) +=nouveau/
 obj-$(CONFIG_DRM_EXYNOS) +=exynos/
+obj-$(CONFIG_DRM_ROCKCHIP) +=rockchip/
 obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
new file mode 100644
index 0000000..9350316
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -0,0 +1,35 @@
+config DRM_ROCKCHIP
+	tristate "DRM Support for Rockchip "
+	depends on DRM
+	select DRM_KMS_HELPER
+	select DRM_KMS_FB_HELPER
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
+	select VIDEOMODE_HELPERS
+	select OF
+	help
+	  Choose this option if you have a  ROCKCHIP soc chipset.
+	  support will be included for lcd controller and display interface.
+	  use dma buffer and iommu to get continus Continuous memory.
+	  If M is selected the module will be called rockchipdrm.
+
+config DRM_ROCKCHIP_IOMMU
+	bool "ROCKCHIP DRM IOMMU Support"
+	depends on DRM_ROCKCHIP && ARM_DMA_USE_IOMMU
+	help
+	  Choose this option if you want to use IOMMU feature for DRM.
+	  support will be included for rk3288 lcd controller.
+	  the IOMMU takes care of mapping device-visible virtual addresses
+	  to physical addresses.
+
+
+config DRM_ROCKCHIP_DMABUF
+	bool "ROCKCHIP DRM DMABUF"
+	depends on DRM_ROCKCHIP
+	help
+	  Choose this option if you want to use DMABUF feature for DRM.
+	  device drivers need dma buffers, we should use dma mapping APIs,
+	  if DRM_ROCKCHIP_IOMMU is not support, CMA should work behind
+	  kernel DMA mapping.
diff --git a/drivers/gpu/drm/rockchip/Makefile b/drivers/gpu/drm/rockchip/Makefile
new file mode 100644
index 0000000..6768319
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the drm device driver.  This driver provides support for the
+# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
+
+ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/rockchip
+rockchipdrm-y := rockchip_drm_drv.o rockchip_drm_encoder.o \
+		rockchip_drm_crtc.o rockchip_drm_fbdev.o rockchip_drm_fb.o \
+		rockchip_drm_buf.o rockchip_drm_gem.o rockchip_drm_core.o \
+		rockchip_drm_plane.o
+
+rockchipdrm-$(CONFIG_DRM_ROCKCHIP_IOMMU) += rockchip_drm_iommu.o
+rockchipdrm-$(CONFIG_DRM_ROCKCHIP_DMABUF) += rockchip_drm_dmabuf.o
+
+obj-$(CONFIG_DRM_ROCKCHIP) += rockchipdrm.o
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_buf.c b/drivers/gpu/drm/rockchip/rockchip_drm_buf.c
new file mode 100644
index 0000000..513d7c1
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_buf.c
@@ -0,0 +1,191 @@
+/* rockchip_drm_buf.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_buf.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_buf.h"
+#include "rockchip_drm_iommu.h"
+
+static int lowlevel_buffer_allocate(struct drm_device *dev,
+		unsigned int flags, struct rockchip_drm_gem_buf *buf)
+{
+	int ret = 0;
+	enum dma_attr attr;
+	unsigned int nr_pages;
+
+	if (buf->dma_addr) {
+		DRM_DEBUG_KMS("already allocated.\n");
+		return 0;
+	}
+
+	init_dma_attrs(&buf->dma_attrs);
+
+	/*
+	 * if ROCKCHIP_BO_CONTIG, fully physically contiguous memory
+	 * region will be allocated else physically contiguous
+	 * as possible.
+	 */
+	if (!(flags & ROCKCHIP_BO_NONCONTIG))
+		dma_set_attr(DMA_ATTR_FORCE_CONTIGUOUS, &buf->dma_attrs);
+
+	/*
+	 * if ROCKCHIP_BO_WC or ROCKCHIP_BO_NONCACHABLE, writecombine mapping
+	 * else cachable mapping.
+	 */
+	if (flags & ROCKCHIP_BO_WC || !(flags & ROCKCHIP_BO_CACHABLE))
+		attr = DMA_ATTR_WRITE_COMBINE;
+	else
+		attr = DMA_ATTR_NON_CONSISTENT;
+
+	dma_set_attr(attr, &buf->dma_attrs);
+	dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->dma_attrs);
+
+	nr_pages = buf->size >> PAGE_SHIFT;
+
+	if (!is_drm_iommu_supported(dev)) {
+		dma_addr_t start_addr;
+		unsigned int i = 0;
+
+		buf->pages = drm_calloc_large(nr_pages, sizeof(struct page *));
+		if (!buf->pages) {
+			DRM_ERROR("failed to allocate pages.\n");
+			return -ENOMEM;
+		}
+
+		buf->kvaddr = (void __iomem *)dma_alloc_attrs(dev->dev,
+					buf->size,
+					&buf->dma_addr, GFP_KERNEL,
+					&buf->dma_attrs);
+		if (!buf->kvaddr) {
+			DRM_ERROR("failed to allocate buffer.\n");
+			ret = -ENOMEM;
+			goto err_free;
+		}
+
+		start_addr = buf->dma_addr;
+		while (i < nr_pages) {
+			buf->pages[i] = phys_to_page(start_addr);
+			start_addr += PAGE_SIZE;
+			i++;
+		}
+	} else {
+
+		buf->pages = dma_alloc_attrs(dev->dev, buf->size,
+					&buf->dma_addr, GFP_KERNEL,
+					&buf->dma_attrs);
+		if (!buf->pages) {
+			DRM_ERROR("failed to allocate buffer.\n");
+			return -ENOMEM;
+		}
+	}
+
+	buf->sgt = drm_prime_pages_to_sg(buf->pages, nr_pages);
+	if (IS_ERR(buf->sgt)) {
+		DRM_ERROR("failed to get sg table.\n");
+		ret = PTR_ERR(buf->sgt);
+		goto err_free_attrs;
+	}
+
+	DRM_DEBUG_KMS("dma_addr(0x%lx), size(0x%lx)\n",
+			(unsigned long)buf->dma_addr,
+			buf->size);
+
+	return ret;
+
+err_free_attrs:
+	dma_free_attrs(dev->dev, buf->size, buf->pages,
+			(dma_addr_t)buf->dma_addr, &buf->dma_attrs);
+	buf->dma_addr = (dma_addr_t)NULL;
+err_free:
+	if (!is_drm_iommu_supported(dev))
+		drm_free_large(buf->pages);
+
+	return ret;
+}
+
+static void lowlevel_buffer_deallocate(struct drm_device *dev,
+		unsigned int flags, struct rockchip_drm_gem_buf *buf)
+{
+	if (!buf->dma_addr) {
+		DRM_DEBUG_KMS("dma_addr is invalid.\n");
+		return;
+	}
+
+	DRM_DEBUG_KMS("dma_addr(0x%lx), size(0x%lx)\n",
+			(unsigned long)buf->dma_addr,
+			buf->size);
+
+	sg_free_table(buf->sgt);
+
+	kfree(buf->sgt);
+	buf->sgt = NULL;
+
+	if (!is_drm_iommu_supported(dev)) {
+		dma_free_attrs(dev->dev, buf->size, buf->kvaddr,
+				(dma_addr_t)buf->dma_addr, &buf->dma_attrs);
+		drm_free_large(buf->pages);
+	} else
+		dma_free_attrs(dev->dev, buf->size, buf->pages,
+				(dma_addr_t)buf->dma_addr, &buf->dma_attrs);
+
+	buf->dma_addr = (dma_addr_t)NULL;
+}
+
+struct rockchip_drm_gem_buf *rockchip_drm_init_buf(struct drm_device *dev,
+						unsigned int size)
+{
+	struct rockchip_drm_gem_buf *buffer;
+
+	DRM_DEBUG_KMS("desired size = 0x%x\n", size);
+
+	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
+	if (!buffer)
+		return NULL;
+
+	buffer->size = size;
+
+	return buffer;
+}
+
+void rockchip_drm_fini_buf(struct drm_device *dev,
+				struct rockchip_drm_gem_buf *buffer)
+{
+	kfree(buffer);
+	buffer = NULL;
+}
+
+int rockchip_drm_alloc_buf(struct drm_device *dev,
+		struct rockchip_drm_gem_buf *buf, unsigned int flags)
+{
+	/*
+	 * allocate memory region and set the memory information
+	 * to vaddr and dma_addr of a buffer object.
+	 */
+	if (lowlevel_buffer_allocate(dev, flags, buf) < 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void rockchip_drm_free_buf(struct drm_device *dev,
+		unsigned int flags, struct rockchip_drm_gem_buf *buffer)
+{
+	lowlevel_buffer_deallocate(dev, flags, buffer);
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_buf.h b/drivers/gpu/drm/rockchip/rockchip_drm_buf.h
new file mode 100644
index 0000000..a4e5d00
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_buf.h
@@ -0,0 +1,39 @@
+/* rockchip_drm_buf.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_buf.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_BUF_H_
+#define _ROCKCHIP_DRM_BUF_H_
+
+/* create and initialize buffer object. */
+struct rockchip_drm_gem_buf *rockchip_drm_init_buf(struct drm_device *dev,
+						unsigned int size);
+
+/* destroy buffer object. */
+void rockchip_drm_fini_buf(struct drm_device *dev,
+				struct rockchip_drm_gem_buf *buffer);
+
+/* allocate physical memory region and setup sgt. */
+int rockchip_drm_alloc_buf(struct drm_device *dev,
+				struct rockchip_drm_gem_buf *buf,
+				unsigned int flags);
+
+/* release physical memory region, and sgt. */
+void rockchip_drm_free_buf(struct drm_device *dev,
+				unsigned int flags,
+				struct rockchip_drm_gem_buf *buffer);
+
+#endif /* _ROCKCHIP_DRM_BUF_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_connector.c b/drivers/gpu/drm/rockchip/rockchip_drm_connector.c
new file mode 100644
index 0000000..3005788
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_connector.c
@@ -0,0 +1,261 @@
+/* rockchip_drm_connector.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_connector.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include <drm/rockchip_drm.h>
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_encoder.h"
+#include "rockchip_drm_connector.h"
+
+#define to_rockchip_connector(x) \
+		container_of(x, struct rockchip_drm_connector, drm_connector)
+
+struct rockchip_drm_connector {
+	struct drm_connector drm_connector;
+	struct rockchip_drm_display *display;
+	uint32_t encoder_id;
+};
+
+static int rockchip_drm_connector_get_modes(struct drm_connector *connector)
+{
+	struct rockchip_drm_connector *rockchip_connector =
+					to_rockchip_connector(connector);
+	struct rockchip_drm_display *display = rockchip_connector->display;
+	struct edid *edid = NULL;
+	unsigned int count = 0;
+	int ret;
+
+	/*
+	 * if get_edid() exists then get_edid() callback of hdmi side
+	 * is called to get edid data through i2c interface else
+	 * get timing from the FIMD driver(display controller).
+	 *
+	 * P.S. in case of lcd panel, count is always 1 if success
+	 * because lcd panel has only one mode.
+	 */
+	if (display->ops->get_edid) {
+		edid = display->ops->get_edid(display, connector);
+		if (IS_ERR_OR_NULL(edid)) {
+			ret = PTR_ERR(edid);
+			edid = NULL;
+			DRM_ERROR("Panel operation get_edid failed %d\n", ret);
+			goto out;
+		}
+
+		count = drm_add_edid_modes(connector, edid);
+		if (!count) {
+			DRM_ERROR("Add edid modes failed %d\n", count);
+			goto out;
+		}
+
+		drm_mode_connector_update_edid_property(connector, edid);
+	} else {
+		struct rockchip_drm_panel_info *panel;
+		struct drm_display_mode *mode =
+					drm_mode_create(connector->dev);
+		if (!mode) {
+			DRM_ERROR("failed to create a new display mode.\n");
+			return 0;
+		}
+
+		if (display->ops->get_panel)
+			panel = display->ops->get_panel(display);
+		else {
+			drm_mode_destroy(connector->dev, mode);
+			return 0;
+		}
+
+		drm_display_mode_from_videomode(&panel->vm, mode);
+		mode->width_mm = panel->width_mm;
+		mode->height_mm = panel->height_mm;
+		connector->display_info.width_mm = mode->width_mm;
+		connector->display_info.height_mm = mode->height_mm;
+
+		mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+		drm_mode_set_name(mode);
+		drm_mode_probed_add(connector, mode);
+
+		count = 1;
+	}
+
+out:
+	kfree(edid);
+	return count;
+}
+
+static int rockchip_drm_connector_mode_valid(struct drm_connector *connector,
+					    struct drm_display_mode *mode)
+{
+	struct rockchip_drm_connector *rockchip_connector =
+					to_rockchip_connector(connector);
+	struct rockchip_drm_display *display = rockchip_connector->display;
+	int ret = MODE_BAD;
+
+	if (display->ops->check_mode)
+		if (!display->ops->check_mode(display, mode))
+			ret = MODE_OK;
+
+	return ret;
+}
+
+static struct drm_encoder *rockchip_drm_best_encoder(
+		struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct rockchip_drm_connector *rockchip_connector =
+					to_rockchip_connector(connector);
+	struct drm_mode_object *obj;
+	struct drm_encoder *encoder;
+
+	obj = drm_mode_object_find(dev, rockchip_connector->encoder_id,
+				   DRM_MODE_OBJECT_ENCODER);
+	if (!obj) {
+		DRM_DEBUG_KMS("Unknown ENCODER ID %d\n",
+				rockchip_connector->encoder_id);
+		return NULL;
+	}
+
+	encoder = obj_to_encoder(obj);
+
+	return encoder;
+}
+
+static struct drm_connector_helper_funcs rockchip_connector_helper_funcs = {
+	.get_modes = rockchip_drm_connector_get_modes,
+	.mode_valid = rockchip_drm_connector_mode_valid,
+	.best_encoder = rockchip_drm_best_encoder,
+};
+
+static int rockchip_drm_connector_fill_modes(struct drm_connector *connector,
+			unsigned int max_width, unsigned int max_height)
+{
+	struct rockchip_drm_connector *rockchip_connector =
+					to_rockchip_connector(connector);
+	struct rockchip_drm_display *display = rockchip_connector->display;
+	unsigned int width, height;
+
+	width = max_width;
+	height = max_height;
+
+	/*
+	 * if specific driver want to find desired_mode using maxmum
+	 * resolution then get max width and height from that driver.
+	 */
+	if (display->ops->get_max_resol)
+		display->ops->get_max_resol(display, &width, &height);
+
+	return drm_helper_probe_single_connector_modes(connector, width,
+							height);
+}
+
+/* get detection status of display device. */
+static enum drm_connector_status
+rockchip_drm_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct rockchip_drm_connector *rockchip_connector =
+					to_rockchip_connector(connector);
+	struct rockchip_drm_display *display = rockchip_connector->display;
+	enum drm_connector_status status = connector_status_disconnected;
+
+	if (display->ops->is_connected) {
+		if (display->ops->is_connected(display))
+			status = connector_status_connected;
+		else
+			status = connector_status_disconnected;
+	}
+
+	return status;
+}
+
+static void rockchip_drm_connector_destroy(struct drm_connector *connector)
+{
+	struct rockchip_drm_connector *rockchip_connector =
+		to_rockchip_connector(connector);
+
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	kfree(rockchip_connector);
+}
+
+static struct drm_connector_funcs rockchip_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.fill_modes = rockchip_drm_connector_fill_modes,
+	.detect = rockchip_drm_connector_detect,
+	.destroy = rockchip_drm_connector_destroy,
+};
+
+struct drm_connector *rockchip_drm_connector_create(struct drm_device *dev,
+						   struct drm_encoder *encoder)
+{
+	struct rockchip_drm_connector *rockchip_connector;
+	struct rockchip_drm_display *display =
+				rockchip_drm_get_display(encoder);
+	struct drm_connector *connector;
+	int type;
+	int err;
+
+	rockchip_connector = kzalloc(sizeof(*rockchip_connector), GFP_KERNEL);
+	if (!rockchip_connector)
+		return NULL;
+
+	connector = &rockchip_connector->drm_connector;
+
+	switch (display->type) {
+	case ROCKCHIP_DISPLAY_TYPE_HDMI:
+		type = DRM_MODE_CONNECTOR_HDMIA;
+		connector->interlace_allowed = true;
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
+		break;
+	case ROCKCHIP_DISPLAY_TYPE_LCD:
+		type = DRM_MODE_CONNECTOR_LVDS;
+		break;
+	default:
+		type = DRM_MODE_CONNECTOR_Unknown;
+		break;
+	}
+
+	drm_connector_init(dev, connector, &rockchip_connector_funcs, type);
+	drm_connector_helper_add(connector, &rockchip_connector_helper_funcs);
+
+	err = drm_sysfs_connector_add(connector);
+	if (err)
+		goto err_connector;
+
+	rockchip_connector->encoder_id = encoder->base.id;
+	rockchip_connector->display = display;
+	connector->dpms = DRM_MODE_DPMS_OFF;
+	connector->encoder = encoder;
+
+	err = drm_mode_connector_attach_encoder(connector, encoder);
+	if (err) {
+		DRM_ERROR("failed to attach a connector to a encoder\n");
+		goto err_sysfs;
+	}
+
+	DRM_DEBUG_KMS("connector has been created\n");
+
+	return connector;
+
+err_sysfs:
+	drm_sysfs_connector_remove(connector);
+err_connector:
+	drm_connector_cleanup(connector);
+	kfree(rockchip_connector);
+	return NULL;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_connector.h b/drivers/gpu/drm/rockchip/rockchip_drm_connector.h
new file mode 100644
index 0000000..6235aba
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_connector.h
@@ -0,0 +1,24 @@
+/* rockchip_drm_connector.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_connector.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_CONNECTOR_H_
+#define _ROCKCHIP_DRM_CONNECTOR_H_
+
+struct drm_connector *rockchip_drm_connector_create(struct drm_device *dev,
+						struct drm_encoder *encoder);
+
+#endif /* _ROCKCHIP_DRM_CONNECTOR_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_core.c b/drivers/gpu/drm/rockchip/rockchip_drm_core.c
new file mode 100644
index 0000000..ebdd3d0
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_core.c
@@ -0,0 +1,163 @@
+/* rockchip_drm_core.c
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_core.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_crtc.h"
+#include "rockchip_drm_encoder.h"
+#include "rockchip_drm_fbdev.h"
+
+static LIST_HEAD(rockchip_drm_subdrv_list);
+
+int rockchip_drm_create_enc_conn(struct drm_device *dev,
+					struct rockchip_drm_display *display)
+{
+	struct drm_encoder *encoder;
+	int ret;
+	unsigned long possible_crtcs = 0;
+
+	ret = rockchip_drm_crtc_get_pipe_from_type(dev, display->type);
+	if (ret < 0)
+		return ret;
+
+	possible_crtcs |= 1 << ret;
+
+	/* create and initialize a encoder for this sub driver. */
+	encoder = rockchip_drm_encoder_create(dev, display, possible_crtcs);
+	if (!encoder) {
+		DRM_ERROR("failed to create encoder\n");
+		return -EFAULT;
+	}
+
+	display->encoder = encoder;
+
+	ret = display->ops->create_connector(display, encoder);
+	if (ret) {
+		DRM_ERROR("failed to create connector ret = %d\n", ret);
+		goto err_destroy_encoder;
+	}
+
+	return 0;
+
+err_destroy_encoder:
+	encoder->funcs->destroy(encoder);
+	return ret;
+}
+
+int rockchip_drm_subdrv_register(struct rockchip_drm_subdrv *subdrv)
+{
+	if (!subdrv)
+		return -EINVAL;
+
+	list_add_tail(&subdrv->list, &rockchip_drm_subdrv_list);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rockchip_drm_subdrv_register);
+
+int rockchip_drm_subdrv_unregister(struct rockchip_drm_subdrv *subdrv)
+{
+	if (!subdrv)
+		return -EINVAL;
+
+	list_del(&subdrv->list);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rockchip_drm_subdrv_unregister);
+
+int rockchip_drm_device_subdrv_probe(struct drm_device *dev)
+{
+	struct rockchip_drm_subdrv *subdrv, *n;
+	int err;
+
+	if (!dev)
+		return -EINVAL;
+
+	list_for_each_entry_safe(subdrv, n, &rockchip_drm_subdrv_list, list) {
+		if (subdrv->probe) {
+			subdrv->drm_dev = dev;
+
+			/*
+			 * this probe callback would be called by sub driver
+			 * after setting of all resources to this sub driver,
+			 * such as clock, irq and register map are done.
+			 */
+			err = subdrv->probe(dev, subdrv->dev);
+			if (err) {
+				DRM_DEBUG("rockchip drm subdrv probe fail.\n");
+				list_del(&subdrv->list);
+				continue;
+			}
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rockchip_drm_device_subdrv_probe);
+
+int rockchip_drm_device_subdrv_remove(struct drm_device *dev)
+{
+	struct rockchip_drm_subdrv *subdrv;
+
+	if (!dev) {
+		WARN(1, "Unexpected drm device unregister!\n");
+		return -EINVAL;
+	}
+
+	list_for_each_entry(subdrv, &rockchip_drm_subdrv_list, list) {
+		if (subdrv->remove)
+			subdrv->remove(dev, subdrv->dev);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rockchip_drm_device_subdrv_remove);
+
+int rockchip_drm_subdrv_open(struct drm_device *dev, struct drm_file *file)
+{
+	struct rockchip_drm_subdrv *subdrv;
+	int ret;
+
+	list_for_each_entry(subdrv, &rockchip_drm_subdrv_list, list) {
+		if (subdrv->open) {
+			ret = subdrv->open(dev, subdrv->dev, file);
+			if (ret)
+				goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	list_for_each_entry_reverse(subdrv, &subdrv->list, list) {
+		if (subdrv->close)
+			subdrv->close(dev, subdrv->dev, file);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(rockchip_drm_subdrv_open);
+
+void rockchip_drm_subdrv_close(struct drm_device *dev, struct drm_file *file)
+{
+	struct rockchip_drm_subdrv *subdrv;
+
+	list_for_each_entry(subdrv, &rockchip_drm_subdrv_list, list) {
+		if (subdrv->close)
+			subdrv->close(dev, subdrv->dev, file);
+	}
+}
+EXPORT_SYMBOL_GPL(rockchip_drm_subdrv_close);
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_crtc.c b/drivers/gpu/drm/rockchip/rockchip_drm_crtc.c
new file mode 100644
index 0000000..2400940
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_crtc.c
@@ -0,0 +1,515 @@
+/* rockchip_drm_crtc.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_crtc.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "rockchip_drm_crtc.h"
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_encoder.h"
+#include "rockchip_drm_plane.h"
+
+#define to_rockchip_crtc(x)	container_of(x, struct rockchip_drm_crtc,\
+				drm_crtc)
+
+enum rockchip_crtc_mode {
+	/* normal mode */
+	CRTC_MODE_NORMAL,
+	/* The private plane of crtc is blank */
+	CRTC_MODE_BLANK,
+};
+
+/*
+ * Rockchip specific crtc structure.
+ *
+ * @drm_crtc: crtc object.
+ * @drm_plane: pointer of private plane object for this crtc
+ * @manager: the manager associated with this crtc
+ * @pipe: a crtc index created at load() with a new crtc object creation
+ *      and the crtc object would be set to private->crtc array
+ *      to get a crtc object corresponding to this pipe from private->crtc
+ *      array when irq interrupt occurred. the reason of using this pipe is that
+ *      drm framework doesn't support multiple irq yet.
+ *      we can refer to the crtc to current hardware interrupt occurred through
+ *      this pipe value.
+ * @dpms: store the crtc dpms value
+ * @mode: store the crtc mode value
+ */
+struct rockchip_drm_crtc {
+	struct drm_crtc drm_crtc;
+	struct drm_plane *plane;
+	struct rockchip_drm_manager *manager;
+	wait_queue_head_t pending_flip_queue;
+	enum rockchip_crtc_mode mode;
+	atomic_t pending_flip;
+	unsigned int pipe;
+	unsigned int dpms;
+};
+
+static void rockchip_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+	struct rockchip_drm_manager *manager = rockchip_crtc->manager;
+
+	DRM_DEBUG_KMS("crtc[%d] mode[%d]\n", crtc->base.id, mode);
+
+	if (rockchip_crtc->dpms == mode) {
+		DRM_DEBUG_KMS("desired dpms mode is same as previous one.\n");
+		return;
+	}
+
+	if (mode > DRM_MODE_DPMS_ON) {
+		/* wait for the completion of page flip. */
+		wait_event(rockchip_crtc->pending_flip_queue,
+			atomic_read(&rockchip_crtc->pending_flip) == 0);
+		drm_vblank_off(crtc->dev, rockchip_crtc->pipe);
+	}
+
+	if (manager->ops->dpms)
+		manager->ops->dpms(manager, mode);
+
+	rockchip_crtc->dpms = mode;
+}
+
+static void rockchip_drm_crtc_prepare(struct drm_crtc *crtc)
+{
+	/* drm framework doesn't check NULL. */
+}
+
+static void rockchip_drm_crtc_commit(struct drm_crtc *crtc)
+{
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+	struct rockchip_drm_manager *manager = rockchip_crtc->manager;
+
+	rockchip_drm_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
+
+	rockchip_plane_commit(rockchip_crtc->plane);
+
+	if (manager->ops->commit)
+		manager->ops->commit(manager);
+
+	rockchip_plane_dpms(rockchip_crtc->plane, DRM_MODE_DPMS_ON);
+}
+
+static bool rockchip_drm_crtc_mode_fixup(struct drm_crtc *crtc,
+				const struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+	struct rockchip_drm_manager *manager = rockchip_crtc->manager;
+
+	if (manager->ops->mode_fixup)
+		return manager->ops->mode_fixup(manager, mode, adjusted_mode);
+
+	return true;
+}
+
+static int rockchip_drm_crtc_mode_set(struct drm_crtc *crtc,
+			struct drm_display_mode *mode,
+			struct drm_display_mode *adjusted_mode, int x, int y,
+			struct drm_framebuffer *old_fb)
+{
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+	struct rockchip_drm_manager *manager = rockchip_crtc->manager;
+	struct drm_plane *plane = rockchip_crtc->plane;
+	unsigned int crtc_w;
+	unsigned int crtc_h;
+	int ret;
+
+	/*
+	 * copy the mode data adjusted by mode_fixup() into crtc->mode
+	 * so that hardware can be seet to proper mode.
+	 */
+	memcpy(&crtc->mode, adjusted_mode, sizeof(*adjusted_mode));
+
+	crtc_w = crtc->primary->fb->width - x;
+	crtc_h = crtc->primary->fb->height - y;
+
+	if (manager->ops->mode_set)
+		manager->ops->mode_set(manager, &crtc->mode);
+
+	ret = rockchip_plane_mode_set(plane, crtc, crtc->primary->fb,
+					0, 0, crtc_w, crtc_h,
+					x, y, crtc_w, crtc_h);
+	if (ret)
+		return ret;
+
+	plane->crtc = crtc;
+	plane->fb = crtc->primary->fb;
+	drm_framebuffer_reference(plane->fb);
+
+	return 0;
+}
+
+static int rockchip_drm_crtc_mode_set_commit(struct drm_crtc *crtc,
+				int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+	struct drm_plane *plane = rockchip_crtc->plane;
+	unsigned int crtc_w;
+	unsigned int crtc_h;
+	int ret;
+
+	/* when framebuffer changing is requested, crtc's dpms should be on */
+	if (rockchip_crtc->dpms > DRM_MODE_DPMS_ON) {
+		DRM_ERROR("failed framebuffer changing request.\n");
+		return -EPERM;
+	}
+
+	crtc_w = crtc->primary->fb->width - x;
+	crtc_h = crtc->primary->fb->height - y;
+
+	ret = rockchip_plane_mode_set(plane, crtc, crtc->primary->fb,
+				0, 0, crtc_w, crtc_h, x, y, crtc_w, crtc_h);
+	if (ret)
+		return ret;
+
+	rockchip_drm_crtc_commit(crtc);
+
+	return 0;
+}
+
+static int rockchip_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
+					  struct drm_framebuffer *old_fb)
+{
+	return rockchip_drm_crtc_mode_set_commit(crtc, x, y, old_fb);
+}
+
+static void rockchip_drm_crtc_disable(struct drm_crtc *crtc)
+{
+	struct drm_plane *plane;
+	int ret;
+
+	rockchip_drm_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
+
+	drm_for_each_legacy_plane(plane, &crtc->dev->mode_config.plane_list) {
+		if (plane->crtc != crtc)
+			continue;
+
+		ret = plane->funcs->disable_plane(plane);
+		if (ret)
+			DRM_ERROR("Failed to disable plane %d\n", ret);
+	}
+}
+
+static struct drm_crtc_helper_funcs rockchip_crtc_helper_funcs = {
+	.dpms = rockchip_drm_crtc_dpms,
+	.prepare = rockchip_drm_crtc_prepare,
+	.commit = rockchip_drm_crtc_commit,
+	.mode_fixup = rockchip_drm_crtc_mode_fixup,
+	.mode_set = rockchip_drm_crtc_mode_set,
+	.mode_set_base = rockchip_drm_crtc_mode_set_base,
+	.disable = rockchip_drm_crtc_disable,
+};
+
+static int rockchip_drm_crtc_page_flip(struct drm_crtc *crtc,
+				     struct drm_framebuffer *fb,
+				     struct drm_pending_vblank_event *event,
+				     uint32_t page_flip_flags)
+{
+	struct drm_device *dev = crtc->dev;
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+	struct drm_framebuffer *old_fb = crtc->primary->fb;
+	int ret = -EINVAL;
+
+	/* when the page flip is requested, crtc's dpms should be on */
+	if (rockchip_crtc->dpms > DRM_MODE_DPMS_ON) {
+		DRM_ERROR("failed page flip request.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&dev->struct_mutex);
+
+	if (event) {
+		/*
+		 * the pipe from user always is 0 so we can set pipe number
+		 * of current owner to event.
+		 */
+		event->pipe = rockchip_crtc->pipe;
+
+		ret = drm_vblank_get(dev, rockchip_crtc->pipe);
+		if (ret) {
+			DRM_DEBUG("failed to acquire vblank counter\n");
+
+			goto out;
+		}
+
+		spin_lock_irq(&dev->event_lock);
+		list_add_tail(&event->base.link,
+				&dev_priv->pageflip_event_list);
+		atomic_set(&rockchip_crtc->pending_flip, 1);
+		spin_unlock_irq(&dev->event_lock);
+
+		crtc->primary->fb = fb;
+		ret = rockchip_drm_crtc_mode_set_commit(crtc, crtc->x, crtc->y,
+						    NULL);
+		if (ret) {
+			crtc->primary->fb = old_fb;
+
+			spin_lock_irq(&dev->event_lock);
+			drm_vblank_put(dev, rockchip_crtc->pipe);
+			list_del(&event->base.link);
+			spin_unlock_irq(&dev->event_lock);
+
+			goto out;
+		}
+	}
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+static void rockchip_drm_crtc_destroy(struct drm_crtc *crtc)
+{
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+	struct rockchip_drm_private *private = crtc->dev->dev_private;
+
+	private->crtc[rockchip_crtc->pipe] = NULL;
+
+	drm_crtc_cleanup(crtc);
+	kfree(rockchip_crtc);
+}
+
+static int rockchip_drm_crtc_set_property(struct drm_crtc *crtc,
+					struct drm_property *property,
+					uint64_t val)
+{
+	struct drm_device *dev = crtc->dev;
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(crtc);
+
+	if (property == dev_priv->crtc_mode_property) {
+		enum rockchip_crtc_mode mode = val;
+
+		if (mode == rockchip_crtc->mode)
+			return 0;
+
+		rockchip_crtc->mode = mode;
+
+		switch (mode) {
+		case CRTC_MODE_NORMAL:
+			rockchip_drm_crtc_commit(crtc);
+			break;
+		case CRTC_MODE_BLANK:
+			rockchip_plane_dpms(rockchip_crtc->plane,
+					  DRM_MODE_DPMS_OFF);
+			break;
+		default:
+			break;
+		}
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct drm_crtc_funcs rockchip_crtc_funcs = {
+	.set_config = drm_crtc_helper_set_config,
+	.page_flip = rockchip_drm_crtc_page_flip,
+	.destroy = rockchip_drm_crtc_destroy,
+	.set_property = rockchip_drm_crtc_set_property,
+};
+
+static const struct drm_prop_enum_list mode_names[] = {
+	{ CRTC_MODE_NORMAL, "normal" },
+	{ CRTC_MODE_BLANK, "blank" },
+};
+
+static void rockchip_drm_crtc_attach_mode_property(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+	struct drm_property *prop;
+
+	prop = dev_priv->crtc_mode_property;
+	if (!prop) {
+		prop = drm_property_create_enum(dev, 0, "mode", mode_names,
+						ARRAY_SIZE(mode_names));
+		if (!prop)
+			return;
+
+		dev_priv->crtc_mode_property = prop;
+	}
+
+	drm_object_attach_property(&crtc->base, prop, 0);
+}
+
+int rockchip_drm_crtc_create(struct rockchip_drm_manager *manager)
+{
+	struct rockchip_drm_crtc *rockchip_crtc;
+	struct rockchip_drm_private *private = manager->drm_dev->dev_private;
+	struct drm_crtc *crtc;
+
+	rockchip_crtc = kzalloc(sizeof(*rockchip_crtc), GFP_KERNEL);
+	if (!rockchip_crtc)
+		return -ENOMEM;
+
+	init_waitqueue_head(&rockchip_crtc->pending_flip_queue);
+	atomic_set(&rockchip_crtc->pending_flip, 0);
+
+	rockchip_crtc->dpms = DRM_MODE_DPMS_OFF;
+	rockchip_crtc->manager = manager;
+	rockchip_crtc->pipe = manager->pipe;
+	rockchip_crtc->plane = rockchip_plane_init(manager->drm_dev,
+				1 << manager->pipe, true);
+	if (!rockchip_crtc->plane) {
+		kfree(rockchip_crtc);
+		return -ENOMEM;
+	}
+
+	manager->crtc = &rockchip_crtc->drm_crtc;
+	crtc = &rockchip_crtc->drm_crtc;
+
+	private->crtc[manager->pipe] = crtc;
+
+	drm_crtc_init(manager->drm_dev, crtc, &rockchip_crtc_funcs);
+	drm_crtc_helper_add(crtc, &rockchip_crtc_helper_funcs);
+
+	rockchip_drm_crtc_attach_mode_property(crtc);
+
+	return 0;
+}
+
+int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct rockchip_drm_crtc *rockchip_crtc =
+		to_rockchip_crtc(private->crtc[pipe]);
+	struct rockchip_drm_manager *manager = rockchip_crtc->manager;
+
+	if (rockchip_crtc->dpms != DRM_MODE_DPMS_ON)
+		return -EPERM;
+
+	if (manager->ops->enable_vblank)
+		manager->ops->enable_vblank(manager);
+
+	return 0;
+}
+
+void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pipe)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct rockchip_drm_crtc *rockchip_crtc =
+		to_rockchip_crtc(private->crtc[pipe]);
+	struct rockchip_drm_manager *manager = rockchip_crtc->manager;
+
+	if (rockchip_crtc->dpms != DRM_MODE_DPMS_ON)
+		return;
+
+	if (manager->ops->disable_vblank)
+		manager->ops->disable_vblank(manager);
+}
+
+void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pipe)
+{
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+	struct drm_pending_vblank_event *e, *t;
+	struct drm_crtc *drm_crtc = dev_priv->crtc[pipe];
+	struct rockchip_drm_crtc *rockchip_crtc = to_rockchip_crtc(drm_crtc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+
+	list_for_each_entry_safe(e, t, &dev_priv->pageflip_event_list,
+			base.link) {
+		/* if event's pipe isn't same as crtc then ignore it. */
+		if (pipe != e->pipe)
+			continue;
+
+		list_del(&e->base.link);
+		drm_send_vblank_event(dev, -1, e);
+		drm_vblank_put(dev, pipe);
+		atomic_set(&rockchip_crtc->pending_flip, 0);
+		wake_up(&rockchip_crtc->pending_flip_queue);
+	}
+
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+}
+
+void rockchip_drm_crtc_plane_mode_set(struct drm_crtc *crtc,
+			struct rockchip_drm_overlay *overlay)
+{
+	struct rockchip_drm_manager *manager = to_rockchip_crtc(crtc)->manager;
+
+	if (manager->ops->win_mode_set)
+		manager->ops->win_mode_set(manager, overlay);
+}
+
+void rockchip_drm_crtc_plane_commit(struct drm_crtc *crtc, int zpos)
+{
+	struct rockchip_drm_manager *manager = to_rockchip_crtc(crtc)->manager;
+
+	if (manager->ops->win_commit)
+		manager->ops->win_commit(manager, zpos);
+}
+
+void rockchip_drm_crtc_plane_enable(struct drm_crtc *crtc, int zpos)
+{
+	struct rockchip_drm_manager *manager = to_rockchip_crtc(crtc)->manager;
+
+	if (manager->ops->win_enable)
+		manager->ops->win_enable(manager, zpos);
+}
+
+void rockchip_drm_crtc_plane_disable(struct drm_crtc *crtc, int zpos)
+{
+	struct rockchip_drm_manager *manager = to_rockchip_crtc(crtc)->manager;
+
+	if (manager->ops->win_disable)
+		manager->ops->win_disable(manager, zpos);
+}
+
+void rockchip_drm_crtc_complete_scanout(struct drm_framebuffer *fb)
+{
+	struct rockchip_drm_manager *manager;
+	struct drm_device *dev = fb->dev;
+	struct drm_crtc *crtc;
+
+	/*
+	 * make sure that overlay data are updated to real hardware
+	 * for all encoders.
+	 */
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		manager = to_rockchip_crtc(crtc)->manager;
+
+		/*
+		 * wait for vblank interrupt
+		 * - this makes sure that overlay data are updated to
+		 *     real hardware.
+		 */
+		if (manager->ops->wait_for_vblank)
+			manager->ops->wait_for_vblank(manager);
+	}
+}
+
+int rockchip_drm_crtc_get_pipe_from_type(struct drm_device *drm_dev,
+					unsigned int out_type)
+{
+	struct drm_crtc *crtc;
+
+	list_for_each_entry(crtc, &drm_dev->mode_config.crtc_list, head) {
+		struct rockchip_drm_crtc *rockchip_crtc;
+
+		rockchip_crtc = to_rockchip_crtc(crtc);
+		if (rockchip_crtc->manager->type == out_type)
+			return rockchip_crtc->manager->pipe;
+	}
+
+	return -EPERM;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_crtc.h b/drivers/gpu/drm/rockchip/rockchip_drm_crtc.h
new file mode 100644
index 0000000..bbf7214
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_crtc.h
@@ -0,0 +1,42 @@
+/* rockchip_drm_crtc.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_crtc.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_CRTC_H_
+#define _ROCKCHIP_DRM_CRTC_H_
+
+struct drm_device;
+struct drm_crtc;
+struct rockchip_drm_manager;
+struct rockchip_drm_overlay;
+
+int rockchip_drm_crtc_create(struct rockchip_drm_manager *manager);
+int rockchip_drm_crtc_enable_vblank(struct drm_device *dev, int pipe);
+void rockchip_drm_crtc_disable_vblank(struct drm_device *dev, int pipe);
+void rockchip_drm_crtc_finish_pageflip(struct drm_device *dev, int pipe);
+void rockchip_drm_crtc_complete_scanout(struct drm_framebuffer *fb);
+
+void rockchip_drm_crtc_plane_mode_set(struct drm_crtc *crtc,
+			struct rockchip_drm_overlay *overlay);
+void rockchip_drm_crtc_plane_commit(struct drm_crtc *crtc, int zpos);
+void rockchip_drm_crtc_plane_enable(struct drm_crtc *crtc, int zpos);
+void rockchip_drm_crtc_plane_disable(struct drm_crtc *crtc, int zpos);
+
+/* This function gets pipe value to crtc device matched with out_type. */
+int rockchip_drm_crtc_get_pipe_from_type(struct drm_device *drm_dev,
+					unsigned int out_type);
+
+#endif /* _ROCKCHIP_DRM_CRTC_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.c b/drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.c
new file mode 100644
index 0000000..d3e237d
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.c
@@ -0,0 +1,290 @@
+/* rockchip_drm_dmabuf.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_dmabuf.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/dma-buf.h>
+#include <drm/drmP.h>
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_dmabuf.h"
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_gem.h"
+
+
+struct rockchip_drm_dmabuf_attachment {
+	struct sg_table sgt;
+	enum dma_data_direction dir;
+	bool is_mapped;
+};
+
+static struct rockchip_drm_gem_obj *dma_buf_to_obj(struct dma_buf *buf)
+{
+	return to_rockchip_gem_obj(buf->priv);
+}
+
+static int rockchip_gem_attach_dma_buf(struct dma_buf *dmabuf,
+					struct device *dev,
+					struct dma_buf_attachment *attach)
+{
+	struct rockchip_drm_dmabuf_attachment *rockchip_attach;
+
+	rockchip_attach = kzalloc(sizeof(*rockchip_attach), GFP_KERNEL);
+	if (!rockchip_attach)
+		return -ENOMEM;
+
+	rockchip_attach->dir = DMA_NONE;
+	attach->priv = rockchip_attach;
+
+	return 0;
+}
+
+static void rockchip_gem_detach_dma_buf(struct dma_buf *dmabuf,
+					struct dma_buf_attachment *attach)
+{
+	struct rockchip_drm_dmabuf_attachment *rockchip_attach = attach->priv;
+	struct sg_table *sgt;
+
+	if (!rockchip_attach)
+		return;
+
+	sgt = &rockchip_attach->sgt;
+
+	if (rockchip_attach->dir != DMA_NONE)
+		dma_unmap_sg(attach->dev, sgt->sgl, sgt->nents,
+				rockchip_attach->dir);
+
+	sg_free_table(sgt);
+	kfree(rockchip_attach);
+	attach->priv = NULL;
+}
+
+static struct sg_table *
+		rockchip_gem_map_dma_buf(struct dma_buf_attachment *attach,
+					enum dma_data_direction dir)
+{
+	struct rockchip_drm_dmabuf_attachment *rockchip_attach = attach->priv;
+	struct rockchip_drm_gem_obj *gem_obj = dma_buf_to_obj(attach->dmabuf);
+	struct drm_device *dev = gem_obj->base.dev;
+	struct rockchip_drm_gem_buf *buf;
+	struct scatterlist *rd, *wr;
+	struct sg_table *sgt = NULL;
+	unsigned int i;
+	int nents, ret;
+
+	/* just return current sgt if already requested. */
+	if (rockchip_attach->dir == dir && rockchip_attach->is_mapped)
+		return &rockchip_attach->sgt;
+
+	buf = gem_obj->buffer;
+	if (!buf) {
+		DRM_ERROR("buffer is null.\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	sgt = &rockchip_attach->sgt;
+
+	ret = sg_alloc_table(sgt, buf->sgt->orig_nents, GFP_KERNEL);
+	if (ret) {
+		DRM_ERROR("failed to alloc sgt.\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	mutex_lock(&dev->struct_mutex);
+
+	rd = buf->sgt->sgl;
+	wr = sgt->sgl;
+	for (i = 0; i < sgt->orig_nents; ++i) {
+		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
+		rd = sg_next(rd);
+		wr = sg_next(wr);
+	}
+
+	if (dir != DMA_NONE) {
+		nents = dma_map_sg(attach->dev, sgt->sgl,
+					sgt->orig_nents, dir);
+		if (!nents) {
+			DRM_ERROR("failed to map sgl with iommu.\n");
+			sg_free_table(sgt);
+			sgt = ERR_PTR(-EIO);
+			goto err_unlock;
+		}
+	}
+
+	rockchip_attach->is_mapped = true;
+	rockchip_attach->dir = dir;
+	attach->priv = rockchip_attach;
+
+	DRM_DEBUG_PRIME("buffer size = 0x%lx\n", buf->size);
+
+err_unlock:
+	mutex_unlock(&dev->struct_mutex);
+	return sgt;
+}
+
+static void rockchip_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
+						struct sg_table *sgt,
+						enum dma_data_direction dir)
+{
+	/* Nothing to do. */
+}
+
+static void *rockchip_gem_dmabuf_kmap_atomic(struct dma_buf *dma_buf,
+						unsigned long page_num)
+{
+	/* TODO */
+
+	return NULL;
+}
+
+static void rockchip_gem_dmabuf_kunmap_atomic(struct dma_buf *dma_buf,
+						unsigned long page_num,
+						void *addr)
+{
+	/* TODO */
+}
+
+static void *rockchip_gem_dmabuf_kmap(struct dma_buf *dma_buf,
+					unsigned long page_num)
+{
+	/* TODO */
+
+	return NULL;
+}
+
+static void rockchip_gem_dmabuf_kunmap(struct dma_buf *dma_buf,
+					unsigned long page_num, void *addr)
+{
+	/* TODO */
+}
+
+static int rockchip_gem_dmabuf_mmap(struct dma_buf *dma_buf,
+	struct vm_area_struct *vma)
+{
+	return -ENOTTY;
+}
+
+static struct dma_buf_ops rockchip_dmabuf_ops = {
+	.attach = rockchip_gem_attach_dma_buf,
+	.detach = rockchip_gem_detach_dma_buf,
+	.map_dma_buf = rockchip_gem_map_dma_buf,
+	.unmap_dma_buf = rockchip_gem_unmap_dma_buf,
+	.kmap = rockchip_gem_dmabuf_kmap,
+	.kmap_atomic = rockchip_gem_dmabuf_kmap_atomic,
+	.kunmap = rockchip_gem_dmabuf_kunmap,
+	.kunmap_atomic = rockchip_gem_dmabuf_kunmap_atomic,
+	.mmap = rockchip_gem_dmabuf_mmap,
+	.release = drm_gem_dmabuf_release,
+};
+
+struct dma_buf *rockchip_dmabuf_prime_export(struct drm_device *drm_dev,
+				struct drm_gem_object *obj, int flags)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj =
+						to_rockchip_gem_obj(obj);
+
+	return dma_buf_export(obj, &rockchip_dmabuf_ops,
+				rockchip_gem_obj->base.size, flags);
+}
+
+struct drm_gem_object *rockchip_dmabuf_prime_import(struct drm_device *drm_dev,
+				struct dma_buf *dma_buf)
+{
+	struct dma_buf_attachment *attach;
+	struct sg_table *sgt;
+	struct scatterlist *sgl;
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct rockchip_drm_gem_buf *buffer;
+	int ret;
+
+	/* is this one of own objects? */
+	if (dma_buf->ops == &rockchip_dmabuf_ops) {
+		struct drm_gem_object *obj;
+
+		obj = dma_buf->priv;
+
+		/* is it from our device? */
+		if (obj->dev == drm_dev) {
+			/*
+			 * Importing dmabuf exported from out own gem increases
+			 * refcount on gem itself instead of f_count of dmabuf.
+			 */
+			drm_gem_object_reference(obj);
+			return obj;
+		}
+	}
+
+	attach = dma_buf_attach(dma_buf, drm_dev->dev);
+	if (IS_ERR(attach))
+		return ERR_PTR(-EINVAL);
+
+	get_dma_buf(dma_buf);
+
+	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	if (IS_ERR(sgt)) {
+		ret = PTR_ERR(sgt);
+		goto err_buf_detach;
+	}
+
+	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
+	if (!buffer) {
+		ret = -ENOMEM;
+		goto err_unmap_attach;
+	}
+
+	rockchip_gem_obj = rockchip_drm_gem_init(drm_dev, dma_buf->size);
+	if (!rockchip_gem_obj) {
+		ret = -ENOMEM;
+		goto err_free_buffer;
+	}
+
+	sgl = sgt->sgl;
+
+	buffer->size = dma_buf->size;
+	buffer->dma_addr = sg_dma_address(sgl);
+
+	if (sgt->nents == 1) {
+		/* always physically continuous memory if sgt->nents is 1. */
+		rockchip_gem_obj->flags |= ROCKCHIP_BO_CONTIG;
+	} else {
+		/*
+		 * this case could be CONTIG or NONCONTIG type but for now
+		 * sets NONCONTIG.
+		 * TODO. we have to find a way that exporter can notify
+		 * the type of its own buffer to importer.
+		 */
+		rockchip_gem_obj->flags |= ROCKCHIP_BO_NONCONTIG;
+	}
+
+	rockchip_gem_obj->buffer = buffer;
+	buffer->sgt = sgt;
+	rockchip_gem_obj->base.import_attach = attach;
+
+	DRM_DEBUG_PRIME("dma_addr = %pad, size = 0x%lx\n", &buffer->dma_addr,
+								buffer->size);
+
+	return &rockchip_gem_obj->base;
+
+err_free_buffer:
+	kfree(buffer);
+	buffer = NULL;
+err_unmap_attach:
+	dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
+err_buf_detach:
+	dma_buf_detach(dma_buf, attach);
+	dma_buf_put(dma_buf);
+
+	return ERR_PTR(ret);
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.h b/drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.h
new file mode 100644
index 0000000..93c1c77
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_dmabuf.h
@@ -0,0 +1,32 @@
+/* rockchip_drm_dmabuf.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_dmabuf.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_DMABUF_H_
+#define _ROCKCHIP_DRM_DMABUF_H_
+
+#ifdef CONFIG_DRM_ROCKCHIP_DMABUF
+struct dma_buf *rockchip_dmabuf_prime_export(struct drm_device *drm_dev,
+				struct drm_gem_object *obj, int flags);
+
+struct drm_gem_object *rockchip_dmabuf_prime_import(struct drm_device *drm_dev,
+						struct dma_buf *dma_buf);
+#else
+#define rockchip_dmabuf_prime_export		NULL
+#define rockchip_dmabuf_prime_import		NULL
+#endif
+
+#endif /* _ROCKCHIP_DRM_DMABUF_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
new file mode 100644
index 0000000..33136ba
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
@@ -0,0 +1,618 @@
+/* rockchip_drm_drv.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_drv.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/pm_runtime.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include <linux/anon_inodes.h>
+#include <linux/component.h>
+
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_crtc.h"
+#include "rockchip_drm_encoder.h"
+#include "rockchip_drm_fbdev.h"
+#include "rockchip_drm_fb.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_plane.h"
+#include "rockchip_drm_dmabuf.h"
+#include "rockchip_drm_iommu.h"
+
+#define DRIVER_NAME	"rockchip"
+#define DRIVER_DESC	"rockchip Soc DRM"
+#define DRIVER_DATE	"20140623"
+#define DRIVER_MAJOR	1
+#define DRIVER_MINOR	0
+
+#define VBLANK_OFF_DELAY	50000
+
+static struct platform_device *rockchip_drm_pdev;
+
+static DEFINE_MUTEX(drm_component_lock);
+static LIST_HEAD(drm_component_list);
+
+struct component_dev {
+	struct list_head list;
+	struct device *crtc_dev;
+	struct device *conn_dev;
+	enum rockchip_drm_output_type out_type;
+	unsigned int dev_type_flag;
+};
+
+static int rockchip_drm_load(struct drm_device *dev, unsigned long flags)
+{
+	struct rockchip_drm_private *private;
+	int ret;
+	int nr;
+
+	private = kzalloc(sizeof(struct rockchip_drm_private), GFP_KERNEL);
+	if (!private)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&private->pageflip_event_list);
+	dev_set_drvdata(dev->dev, dev);
+	dev->dev_private = (void *)private;
+
+	/*
+	 * create mapping to manage iommu table and set a pointer to iommu
+	 * mapping structure to iommu_mapping of private data.
+	 * also this iommu_mapping can be used to check if iommu is supported
+	 * or not.
+	 */
+	ret = drm_create_iommu_mapping(dev);
+	if (ret < 0) {
+		DRM_ERROR("failed to create iommu mapping.\n");
+		goto err_free_private;
+	}
+
+	drm_mode_config_init(dev);
+
+	rockchip_drm_mode_config_init(dev);
+
+	for (nr = 0; nr < MAX_PLANE; nr++) {
+		struct drm_plane *plane;
+		unsigned long possible_crtcs = (1 << MAX_CRTC) - 1;
+
+		plane = rockchip_plane_init(dev, possible_crtcs, false);
+		if (!plane)
+			goto err_mode_config_cleanup;
+	}
+
+	/* init kms poll for handling hpd */
+	drm_kms_helper_poll_init(dev);
+
+	ret = drm_vblank_init(dev, MAX_CRTC);
+	if (ret)
+		goto err_mode_config_cleanup;
+
+	/* setup possible_clones. */
+	rockchip_drm_encoder_setup(dev);
+
+	drm_vblank_offdelay = VBLANK_OFF_DELAY;
+
+	platform_set_drvdata(dev->platformdev, dev);
+
+	/* Try to bind all sub drivers. */
+	ret = component_bind_all(dev->dev, dev);
+	if (ret)
+		goto err_cleanup_vblank;
+
+	/* Probe non kms sub drivers and virtual display driver. */
+	ret = rockchip_drm_device_subdrv_probe(dev);
+	if (ret)
+		goto err_unbind_all;
+
+	/* force connectors detection */
+	drm_helper_hpd_irq_event(dev);
+
+	return 0;
+
+err_unbind_all:
+	component_unbind_all(dev->dev, dev);
+err_cleanup_vblank:
+	drm_vblank_cleanup(dev);
+err_mode_config_cleanup:
+	drm_mode_config_cleanup(dev);
+	drm_release_iommu_mapping(dev);
+err_free_private:
+	kfree(private);
+
+	return ret;
+}
+
+static int rockchip_drm_unload(struct drm_device *dev)
+{
+	rockchip_drm_device_subdrv_remove(dev);
+
+	rockchip_drm_fbdev_fini(dev);
+	drm_vblank_cleanup(dev);
+	drm_kms_helper_poll_fini(dev);
+	drm_mode_config_cleanup(dev);
+
+	drm_release_iommu_mapping(dev);
+	kfree(dev->dev_private);
+
+	component_unbind_all(dev->dev, dev);
+	dev->dev_private = NULL;
+
+	return 0;
+}
+
+static const struct file_operations rockchip_drm_gem_fops = {
+	.mmap = rockchip_drm_gem_mmap_buffer,
+};
+
+static int rockchip_drm_suspend(struct drm_device *dev, pm_message_t state)
+{
+	struct drm_connector *connector;
+
+	drm_modeset_lock_all(dev);
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		int old_dpms = connector->dpms;
+
+		if (connector->funcs->dpms)
+			connector->funcs->dpms(connector, DRM_MODE_DPMS_OFF);
+
+		/* Set the old mode back to the connector for resume */
+		connector->dpms = old_dpms;
+	}
+	drm_modeset_unlock_all(dev);
+
+	return 0;
+}
+
+static int rockchip_drm_resume(struct drm_device *dev)
+{
+	struct drm_connector *connector;
+
+	drm_modeset_lock_all(dev);
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->funcs->dpms)
+			connector->funcs->dpms(connector, connector->dpms);
+	}
+	drm_modeset_unlock_all(dev);
+
+	drm_helper_resume_force_mode(dev);
+
+	return 0;
+}
+
+static int rockchip_drm_open(struct drm_device *dev, struct drm_file *file)
+{
+	struct drm_rockchip_file_private *file_priv;
+	struct file *anon_filp;
+	int ret;
+
+	file_priv = kzalloc(sizeof(*file_priv), GFP_KERNEL);
+	if (!file_priv)
+		return -ENOMEM;
+
+	file->driver_priv = file_priv;
+
+	ret = rockchip_drm_subdrv_open(dev, file);
+	if (ret)
+		goto err_file_priv_free;
+
+	anon_filp = anon_inode_getfile("rockchip_gem", &rockchip_drm_gem_fops,
+					NULL, 0);
+	if (IS_ERR(anon_filp)) {
+		ret = PTR_ERR(anon_filp);
+		goto err_subdrv_close;
+	}
+
+	anon_filp->f_mode = FMODE_READ | FMODE_WRITE;
+	file_priv->anon_filp = anon_filp;
+
+	return ret;
+
+err_subdrv_close:
+	rockchip_drm_subdrv_close(dev, file);
+
+err_file_priv_free:
+	kfree(file_priv);
+	file->driver_priv = NULL;
+	return ret;
+}
+
+static void rockchip_drm_preclose(struct drm_device *dev,
+					struct drm_file *file)
+{
+	rockchip_drm_subdrv_close(dev, file);
+}
+
+static void rockchip_drm_postclose(struct drm_device *dev,
+					struct drm_file *file)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct drm_rockchip_file_private *file_priv;
+	struct drm_pending_vblank_event *v, *vt;
+	struct drm_pending_event *e, *et;
+	unsigned long flags;
+
+	if (!file->driver_priv)
+		return;
+
+	/* Release all events not unhandled by page flip handler. */
+	spin_lock_irqsave(&dev->event_lock, flags);
+	list_for_each_entry_safe(v, vt, &private->pageflip_event_list,
+			base.link) {
+		if (v->base.file_priv == file) {
+			list_del(&v->base.link);
+			drm_vblank_put(dev, v->pipe);
+			v->base.destroy(&v->base);
+		}
+	}
+
+	/* Release all events handled by page flip handler but not freed. */
+	list_for_each_entry_safe(e, et, &file->event_list, link) {
+		list_del(&e->link);
+		e->destroy(e);
+	}
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	file_priv = file->driver_priv;
+	if (file_priv->anon_filp)
+		fput(file_priv->anon_filp);
+
+	kfree(file->driver_priv);
+	file->driver_priv = NULL;
+}
+
+static void rockchip_drm_lastclose(struct drm_device *dev)
+{
+	rockchip_drm_fbdev_restore_mode(dev);
+}
+
+static const struct vm_operations_struct rockchip_drm_gem_vm_ops = {
+	.fault = rockchip_drm_gem_fault,
+	.open = drm_gem_vm_open,
+	.close = drm_gem_vm_close,
+};
+
+static const struct drm_ioctl_desc rockchip_ioctls[] = {
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_CREATE, rockchip_drm_gem_create_ioctl,
+			DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_MAP_OFFSET,
+			rockchip_drm_gem_map_offset_ioctl, DRM_UNLOCKED |
+			DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_MMAP,
+			rockchip_drm_gem_mmap_ioctl, DRM_UNLOCKED | DRM_AUTH),
+	DRM_IOCTL_DEF_DRV(ROCKCHIP_GEM_GET,
+			rockchip_drm_gem_get_ioctl, DRM_UNLOCKED),
+};
+
+static const struct file_operations rockchip_drm_driver_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.mmap = rockchip_drm_gem_mmap,
+	.poll = drm_poll,
+	.read = drm_read,
+	.unlocked_ioctl = drm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = drm_compat_ioctl,
+#endif
+	.release = drm_release,
+};
+
+static struct drm_driver rockchip_drm_driver = {
+	.driver_features	= DRIVER_MODESET | DRIVER_GEM | DRIVER_PRIME,
+	.load			= rockchip_drm_load,
+	.unload			= rockchip_drm_unload,
+	.suspend		= rockchip_drm_suspend,
+	.resume			= rockchip_drm_resume,
+	.open			= rockchip_drm_open,
+	.preclose		= rockchip_drm_preclose,
+	.lastclose		= rockchip_drm_lastclose,
+	.postclose		= rockchip_drm_postclose,
+	.get_vblank_counter	= drm_vblank_count,
+	.enable_vblank		= rockchip_drm_crtc_enable_vblank,
+	.disable_vblank		= rockchip_drm_crtc_disable_vblank,
+	.gem_free_object	= rockchip_drm_gem_free_object,
+	.gem_vm_ops		= &rockchip_drm_gem_vm_ops,
+	.dumb_create		= rockchip_drm_gem_dumb_create,
+	.dumb_map_offset	= rockchip_drm_gem_dumb_map_offset,
+	.dumb_destroy		= drm_gem_dumb_destroy,
+	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
+	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
+	.gem_prime_export	= rockchip_dmabuf_prime_export,
+	.gem_prime_import	= rockchip_dmabuf_prime_import,
+	.ioctls			= rockchip_ioctls,
+	.num_ioctls		= ARRAY_SIZE(rockchip_ioctls),
+	.fops			= &rockchip_drm_driver_fops,
+	.name	= DRIVER_NAME,
+	.desc	= DRIVER_DESC,
+	.date	= DRIVER_DATE,
+	.major	= DRIVER_MAJOR,
+	.minor	= DRIVER_MINOR,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int rockchip_drm_sys_suspend(struct device *dev)
+{
+	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	pm_message_t message;
+
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	message.event = PM_EVENT_SUSPEND;
+
+	return rockchip_drm_suspend(drm_dev, message);
+}
+
+static int rockchip_drm_sys_resume(struct device *dev)
+{
+	struct drm_device *drm_dev = dev_get_drvdata(dev);
+
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return rockchip_drm_resume(drm_dev);
+}
+#endif
+
+static const struct dev_pm_ops rockchip_drm_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(rockchip_drm_sys_suspend,
+					rockchip_drm_sys_resume)
+};
+
+int rockchip_drm_component_add(struct device *dev,
+				enum rockchip_drm_device_type dev_type,
+				enum rockchip_drm_output_type out_type)
+{
+	struct component_dev *cdev;
+
+	if (dev_type != ROCKCHIP_DEVICE_TYPE_CRTC &&
+			dev_type != ROCKCHIP_DEVICE_TYPE_CONNECTOR) {
+		DRM_ERROR("invalid device type.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&drm_component_lock);
+
+	/*
+	 * Make sure to check if there is a component which has two device
+	 * objects, for connector and for encoder/connector.
+	 * It should make sure that crtc and encoder/connector drivers are
+	 * ready before rockchip drm core binds them.
+	 */
+	list_for_each_entry(cdev, &drm_component_list, list) {
+		if (cdev->out_type == out_type) {
+			/*
+			 * If crtc and encoder/connector device objects are
+			 * added already just return.
+			 */
+			if (cdev->dev_type_flag == (ROCKCHIP_DEVICE_TYPE_CRTC |
+					ROCKCHIP_DEVICE_TYPE_CONNECTOR)) {
+				mutex_unlock(&drm_component_lock);
+				return 0;
+			}
+
+			if (dev_type == ROCKCHIP_DEVICE_TYPE_CRTC) {
+				cdev->crtc_dev = dev;
+				cdev->dev_type_flag |= dev_type;
+			}
+
+			if (dev_type == ROCKCHIP_DEVICE_TYPE_CONNECTOR) {
+				cdev->conn_dev = dev;
+				cdev->dev_type_flag |= dev_type;
+			}
+
+			mutex_unlock(&drm_component_lock);
+			return 0;
+		}
+	}
+
+	mutex_unlock(&drm_component_lock);
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return -ENOMEM;
+
+	if (dev_type == ROCKCHIP_DEVICE_TYPE_CRTC)
+		cdev->crtc_dev = dev;
+	if (dev_type == ROCKCHIP_DEVICE_TYPE_CONNECTOR)
+		cdev->conn_dev = dev;
+
+	cdev->out_type = out_type;
+	cdev->dev_type_flag = dev_type;
+
+	mutex_lock(&drm_component_lock);
+	list_add_tail(&cdev->list, &drm_component_list);
+	mutex_unlock(&drm_component_lock);
+
+	return 0;
+}
+
+void rockchip_drm_component_del(struct device *dev,
+				enum rockchip_drm_device_type dev_type)
+{
+	struct component_dev *cdev, *next;
+
+	mutex_lock(&drm_component_lock);
+
+	list_for_each_entry_safe(cdev, next, &drm_component_list, list) {
+		if (dev_type == ROCKCHIP_DEVICE_TYPE_CRTC) {
+			if (cdev->crtc_dev == dev) {
+				cdev->crtc_dev = NULL;
+				cdev->dev_type_flag &= ~dev_type;
+			}
+		}
+
+		if (dev_type == ROCKCHIP_DEVICE_TYPE_CONNECTOR) {
+			if (cdev->conn_dev == dev) {
+				cdev->conn_dev = NULL;
+				cdev->dev_type_flag &= ~dev_type;
+			}
+		}
+
+		/*
+		 * Release cdev object only in case that both of crtc and
+		 * encoder/connector device objects are NULL.
+		 */
+		if (!cdev->crtc_dev && !cdev->conn_dev) {
+			list_del(&cdev->list);
+			kfree(cdev);
+		}
+
+		break;
+	}
+
+	mutex_unlock(&drm_component_lock);
+}
+
+static int compare_of(struct device *dev, void *data)
+{
+	return dev == (struct device *)data;
+}
+
+static int rockchip_drm_add_components(struct device *dev, struct master *m)
+{
+	struct component_dev *cdev;
+	unsigned int attach_cnt = 0;
+
+	mutex_lock(&drm_component_lock);
+
+	list_for_each_entry(cdev, &drm_component_list, list) {
+		int ret;
+
+		/*
+		 * Add components to master only in case that crtc and
+		 * encoder/connector device objects exist.
+		 */
+		if (!cdev->crtc_dev || !cdev->conn_dev)
+			continue;
+
+		attach_cnt++;
+
+		mutex_unlock(&drm_component_lock);
+
+		/*
+		 * lcdc and dp modules have same device object so add
+		 * only crtc device object in this case.
+		 *
+		 * TODO. if dp module follows driver-model driver then
+		 * below codes can be removed.
+		 */
+		if (cdev->crtc_dev == cdev->conn_dev) {
+			ret = component_master_add_child(m, compare_of,
+					cdev->crtc_dev);
+			if (ret < 0)
+				return ret;
+
+			goto out_lock;
+		}
+
+		/*
+		 * Do not chage below call order.
+		 * crtc device first should be added to master because
+		 * connector/encoder need pipe number of crtc when they
+		 * are created.
+		 */
+		ret = component_master_add_child(m, compare_of, cdev->crtc_dev);
+		ret |= component_master_add_child(m, compare_of,
+							cdev->conn_dev);
+		if (ret < 0)
+			return ret;
+
+out_lock:
+		mutex_lock(&drm_component_lock);
+	}
+
+	mutex_unlock(&drm_component_lock);
+
+	return attach_cnt ? 0 : -ENODEV;
+}
+
+static int rockchip_drm_bind(struct device *dev)
+{
+	return drm_platform_init(&rockchip_drm_driver, to_platform_device(dev));
+}
+
+static void rockchip_drm_unbind(struct device *dev)
+{
+	drm_put_dev(dev_get_drvdata(dev));
+}
+
+static const struct component_master_ops rockchip_drm_ops = {
+	.add_components = rockchip_drm_add_components,
+	.bind = rockchip_drm_bind,
+	.unbind = rockchip_drm_unbind,
+};
+
+static int rockchip_drm_platform_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	rockchip_drm_driver.num_ioctls = ARRAY_SIZE(rockchip_ioctls);
+
+	ret = component_master_add(&pdev->dev, &rockchip_drm_ops);
+	if (ret < 0)
+		DRM_DEBUG_KMS("re-tried by last sub driver probed later.\n");
+
+	return 0;
+}
+
+static int rockchip_drm_platform_remove(struct platform_device *pdev)
+{
+	component_master_del(&pdev->dev, &rockchip_drm_ops);
+
+	return 0;
+}
+
+static struct platform_driver rockchip_drm_platform_driver = {
+	.probe = rockchip_drm_platform_probe,
+	.remove = rockchip_drm_platform_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "rockchip-drm",
+		.pm = &rockchip_drm_pm_ops,
+	},
+};
+
+static int rockchip_drm_init(void)
+{
+	int ret;
+
+	rockchip_drm_pdev = platform_device_register_simple("rockchip-drm", -1,
+								NULL, 0);
+	if (IS_ERR(rockchip_drm_pdev))
+		return PTR_ERR(rockchip_drm_pdev);
+
+	ret = platform_driver_register(&rockchip_drm_platform_driver);
+	if (ret)
+		goto err_unregister_pd;
+
+	return 0;
+
+err_unregister_pd:
+	platform_device_unregister(rockchip_drm_pdev);
+
+	return ret;
+}
+
+static void rockchip_drm_exit(void)
+{
+	platform_device_unregister(rockchip_drm_pdev);
+	platform_driver_unregister(&rockchip_drm_platform_driver);
+}
+
+module_init(rockchip_drm_init);
+module_exit(rockchip_drm_exit);
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_drv.h b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
new file mode 100644
index 0000000..6340452
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.h
@@ -0,0 +1,319 @@
+/* rockchip_drm_drv.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_drv.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_DRV_H_
+#define _ROCKCHIP_DRM_DRV_H_
+
+#include <linux/module.h>
+
+#define MAX_CRTC	3
+#define MAX_PLANE	5
+#define MAX_FB_BUFFER	4
+#define DEFAULT_ZPOS	-1
+
+#define _wait_for(COND, MS) ({ \
+	unsigned long timeout__ = jiffies + msecs_to_jiffies(MS);	\
+	int ret__ = 0;							\
+	while (!(COND)) {						\
+		if (time_after(jiffies, timeout__)) {			\
+			ret__ = -ETIMEDOUT;				\
+			break;						\
+		}							\
+	}								\
+	ret__;								\
+})
+
+#define wait_for(COND, MS) _wait_for(COND, MS)
+
+struct drm_device;
+struct drm_connector;
+struct rockchip_drm_overlay;
+struct rockchip_drm_manager;
+
+extern unsigned int drm_vblank_offdelay;
+
+/* This enumerates device type. */
+enum rockchip_drm_device_type {
+	ROCKCHIP_DEVICE_TYPE_NONE,
+	ROCKCHIP_DEVICE_TYPE_CRTC,
+	ROCKCHIP_DEVICE_TYPE_CONNECTOR,
+};
+
+/* this enumerates display type. */
+enum rockchip_drm_output_type {
+	ROCKCHIP_DISPLAY_TYPE_NONE,
+	/* RGB or CPU Interface. */
+	ROCKCHIP_DISPLAY_TYPE_LCD,
+	/* HDMI Interface. */
+	ROCKCHIP_DISPLAY_TYPE_HDMI,
+	/* Virtual Display Interface. */
+	ROCKCHIP_DISPLAY_TYPE_VIDI,
+};
+
+/*
+ * Rockchip drm common overlay structure.
+ *
+ * @fb_x: offset x on a framebuffer to be displayed.
+ *      - the unit is screen coordinates.
+ * @fb_y: offset y on a framebuffer to be displayed.
+ *      - the unit is screen coordinates.
+ * @fb_width: width of a framebuffer.
+ * @fb_height: height of a framebuffer.
+ * @src_width: width of a partial image to be displayed from framebuffer.
+ * @src_height: height of a partial image to be displayed from framebuffer.
+ * @crtc_x: offset x on hardware screen.
+ * @crtc_y: offset y on hardware screen.
+ * @crtc_width: window width to be displayed (hardware screen).
+ * @crtc_height: window height to be displayed (hardware screen).
+ * @mode_width: width of screen mode.
+ * @mode_height: height of screen mode.
+ * @refresh: refresh rate.
+ * @scan_flag: interlace or progressive way.
+ *      (it could be DRM_MODE_FLAG_*)
+ * @bpp: pixel size.(in bit)
+ * @pixel_format: fourcc pixel format of this overlay
+ * @dma_addr: array of bus(accessed by dma) address to the memory region
+ *          allocated for a overlay.
+ * @zpos: order of overlay layer(z position).
+ * @default_win: a window to be enabled.
+ * @color_key: color key on or off.
+ * @index_color: if using color key feature then this value would be used
+ *             as index color.
+ * @local_path: in case of lcd type, local path mode on or off.
+ * @transparency: transparency on or off.
+ * @activated: activated or not.
+ *
+ * this structure is common to rockchip SoC and its contents would be copied
+ * to hardware specific overlay info.
+ */
+struct rockchip_drm_overlay {
+	unsigned int fb_x;
+	unsigned int fb_y;
+	unsigned int fb_width;
+	unsigned int fb_height;
+	unsigned int src_width;
+	unsigned int src_height;
+	unsigned int crtc_x;
+	unsigned int crtc_y;
+	unsigned int crtc_width;
+	unsigned int crtc_height;
+	unsigned int mode_width;
+	unsigned int mode_height;
+	unsigned int refresh;
+	unsigned int scan_flag;
+	unsigned int bpp;
+	unsigned int pitch;
+	uint32_t pixel_format;
+	dma_addr_t dma_addr[MAX_FB_BUFFER];
+	int zpos;
+
+	bool default_win;
+	bool color_key;
+	unsigned int index_color;
+	bool local_path;
+	bool transparency;
+	bool activated;
+};
+
+/*
+ * Rockchip DRM Display Structure.
+ *     - this structure is common to analog tv, digital tv and lcd panel.
+ *
+ * @remove: cleans up the display for removal
+ * @mode_fixup: fix mode data comparing to hw specific display mode.
+ * @mode_set: convert drm_display_mode to hw specific display mode and
+ *            would be called by encoder->mode_set().
+ * @check_mode: check if mode is valid or not.
+ * @dpms: display device on or off.
+ * @commit: apply changes to hw
+ */
+struct rockchip_drm_display;
+struct rockchip_drm_display_ops {
+	int (*create_connector)(struct rockchip_drm_display *display,
+				struct drm_encoder *encoder);
+	void (*remove)(struct rockchip_drm_display *display);
+	void (*mode_fixup)(struct rockchip_drm_display *display,
+				struct drm_connector *connector,
+				const struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode);
+	void (*mode_set)(struct rockchip_drm_display *display,
+				struct drm_display_mode *mode);
+	int (*check_mode)(struct rockchip_drm_display *display,
+				struct drm_display_mode *mode);
+	void (*dpms)(struct rockchip_drm_display *display, int mode);
+	void (*commit)(struct rockchip_drm_display *display);
+};
+
+/*
+ * Rockchip drm display structure, maps 1:1 with an encoder/connector
+ *
+ * @list: the list entry for this manager
+ * @type: one of ROCKCHIP_DISPLAY_TYPE_LCD and HDMI.
+ * @encoder: encoder object this display maps to
+ * @connector: connector object this display maps to
+ * @ops: pointer to callbacks for rockchip drm specific functionality
+ * @ctx: A pointer to the display's implementation specific context
+ */
+struct rockchip_drm_display {
+	struct list_head list;
+	enum rockchip_drm_output_type type;
+	struct drm_encoder *encoder;
+	struct drm_connector *connector;
+	struct rockchip_drm_display_ops *ops;
+	void *ctx;
+};
+
+/*
+ * Rockchip drm manager ops
+ *
+ * @dpms: control device power.
+ * @mode_fixup: fix mode data before applying it
+ * @mode_set: set the given mode to the manager
+ * @commit: set current hw specific display mode to hw.
+ * @enable_vblank: specific driver callback for enabling vblank interrupt.
+ * @disable_vblank: specific driver callback for disabling vblank interrupt.
+ * @wait_for_vblank: wait for vblank interrupt to make sure that
+ *      hardware overlay is updated.
+ * @win_mode_set: copy drm overlay info to hw specific overlay info.
+ * @win_commit: apply hardware specific overlay data to registers.
+ * @win_enable: enable hardware specific overlay.
+ * @win_disable: disable hardware specific overlay.
+ */
+struct rockchip_drm_manager_ops {
+	void (*dpms)(struct rockchip_drm_manager *mgr, int mode);
+	bool (*mode_fixup)(struct rockchip_drm_manager *mgr,
+				const struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode);
+	void (*mode_set)(struct rockchip_drm_manager *mgr,
+				const struct drm_display_mode *mode);
+	void (*commit)(struct rockchip_drm_manager *mgr);
+	int (*enable_vblank)(struct rockchip_drm_manager *mgr);
+	void (*disable_vblank)(struct rockchip_drm_manager *mgr);
+	void (*wait_for_vblank)(struct rockchip_drm_manager *mgr);
+	void (*win_mode_set)(struct rockchip_drm_manager *mgr,
+				struct rockchip_drm_overlay *overlay);
+	void (*win_commit)(struct rockchip_drm_manager *mgr, int zpos);
+	void (*win_enable)(struct rockchip_drm_manager *mgr, int zpos);
+	void (*win_disable)(struct rockchip_drm_manager *mgr, int zpos);
+};
+
+/*
+ * Rockchip drm common manager structure, maps 1:1 with a crtc
+ *
+ * @list: the list entry for this manager
+ * @type: one of ROCKCHIP_DISPLAY_TYPE_LCD and HDMI.
+ * @drm_dev: pointer to the drm device
+ * @crtc: crtc object.
+ * @pipe: the pipe number for this crtc/manager
+ * @ops: pointer to callbacks for rockchip drm specific functionality
+ * @ctx: A pointer to the manager's implementation specific context
+ */
+struct rockchip_drm_manager {
+	struct list_head list;
+	enum rockchip_drm_output_type type;
+	struct drm_device *drm_dev;
+	struct drm_crtc *crtc;
+	int pipe;
+	struct rockchip_drm_manager_ops *ops;
+	void *ctx;
+};
+
+struct drm_rockchip_file_private {
+	struct file *anon_filp;
+};
+
+/*
+ * Rockchip drm private structure.
+ *
+ * @da_start: start address to device address space.
+ *      with iommu, device address space starts from this address
+ *      otherwise default one.
+ * @da_space_size: size of device address space.
+ *      if 0 then default value is used for it.
+ * @pipe: the pipe number for this crtc/manager.
+ */
+struct rockchip_drm_private {
+	struct drm_fb_helper *fb_helper;
+
+	/* list head for new event to be added. */
+	struct list_head pageflip_event_list;
+
+	/*
+	 * created crtc object would be contained at this array and
+	 * this array is used to be aware of which crtc did it request vblank.
+	 */
+	struct drm_crtc *crtc[MAX_CRTC];
+	struct drm_property *plane_zpos_property;
+	struct drm_property *crtc_mode_property;
+
+	unsigned long da_start;
+	unsigned long da_space_size;
+
+	unsigned int pipe;
+};
+
+/*
+ * Rockchip drm sub driver structure.
+ *
+ * @list: sub driver has its own list object to register to rockchip drm driver.
+ * @dev: pointer to device object for subdrv device driver.
+ * @drm_dev: pointer to drm_device and this pointer would be set
+ *      when sub driver calls rockchip_drm_subdrv_register().
+ * @manager: subdrv has its own manager to control a hardware appropriately
+ *     and we can access a hardware drawing on this manager.
+ * @probe: this callback would be called by rockchip drm driver after
+ *     subdrv is registered to it.
+ * @remove: this callback is used to release resources created
+ *     by probe callback.
+ * @open: this would be called with drm device file open.
+ * @close: this would be called with drm device file close.
+ */
+struct rockchip_drm_subdrv {
+	struct list_head list;
+	struct device *dev;
+	struct drm_device *drm_dev;
+
+	int (*probe)(struct drm_device *drm_dev, struct device *dev);
+	void (*remove)(struct drm_device *drm_dev, struct device *dev);
+	int (*open)(struct drm_device *drm_dev, struct device *dev,
+			struct drm_file *file);
+	void (*close)(struct drm_device *drm_dev, struct device *dev,
+			struct drm_file *file);
+};
+
+ /* This function would be called by non kms drivers. */
+int rockchip_drm_subdrv_register(struct rockchip_drm_subdrv *drm_subdrv);
+
+/* this function removes subdrv list from rockchip drm driver */
+int rockchip_drm_subdrv_unregister(struct rockchip_drm_subdrv *drm_subdrv);
+
+int rockchip_drm_device_subdrv_probe(struct drm_device *dev);
+int rockchip_drm_device_subdrv_remove(struct drm_device *dev);
+int rockchip_drm_subdrv_open(struct drm_device *dev, struct drm_file *file);
+void rockchip_drm_subdrv_close(struct drm_device *dev, struct drm_file *file);
+
+/* This function creates a encoder and a connector, and initializes them. */
+int rockchip_drm_create_enc_conn(struct drm_device *dev,
+				struct rockchip_drm_display *display);
+
+int rockchip_drm_component_add(struct device *dev,
+				enum rockchip_drm_device_type dev_type,
+				enum rockchip_drm_output_type out_type);
+
+void rockchip_drm_component_del(struct device *dev,
+				enum rockchip_drm_device_type dev_type);
+#endif /* _ROCKCHIP_DRM_DRV_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_encoder.c b/drivers/gpu/drm/rockchip/rockchip_drm_encoder.c
new file mode 100644
index 0000000..adc82ed
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_encoder.c
@@ -0,0 +1,206 @@
+/* rockchip_drm_encoder.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_encoder.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_encoder.h"
+
+#define to_rockchip_encoder(x)	container_of(x, struct rockchip_drm_encoder,\
+				drm_encoder)
+
+/*
+ * rockchip specific encoder structure.
+ *
+ * @drm_encoder: encoder object.
+ * @display: the display structure that maps to this encoder
+ */
+struct rockchip_drm_encoder {
+	struct drm_encoder drm_encoder;
+	struct rockchip_drm_display *display;
+};
+
+static void rockchip_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct rockchip_drm_encoder *rockchip_encoder =
+						to_rockchip_encoder(encoder);
+	struct rockchip_drm_display *display = rockchip_encoder->display;
+
+	DRM_DEBUG_KMS("encoder dpms: %d\n", mode);
+
+	if (display->ops->dpms)
+		display->ops->dpms(display, mode);
+}
+
+static bool
+rockchip_drm_encoder_mode_fixup(struct drm_encoder *encoder,
+			       const struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct rockchip_drm_encoder *rockchip_encoder =
+						to_rockchip_encoder(encoder);
+	struct rockchip_drm_display *display = rockchip_encoder->display;
+	struct drm_connector *connector;
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->encoder != encoder)
+			continue;
+
+		if (display->ops->mode_fixup)
+			display->ops->mode_fixup(display, connector, mode,
+					adjusted_mode);
+	}
+
+	return true;
+}
+
+static void rockchip_drm_encoder_mode_set(struct drm_encoder *encoder,
+					struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode)
+{
+	struct rockchip_drm_encoder *rockchip_encoder =
+						to_rockchip_encoder(encoder);
+	struct rockchip_drm_display *display = rockchip_encoder->display;
+
+	if (display->ops->mode_set)
+		display->ops->mode_set(display, adjusted_mode);
+}
+
+static void rockchip_drm_encoder_prepare(struct drm_encoder *encoder)
+{
+	/* drm framework doesn't check NULL. */
+}
+
+static void rockchip_drm_encoder_commit(struct drm_encoder *encoder)
+{
+	struct rockchip_drm_encoder *rockchip_encoder =
+						to_rockchip_encoder(encoder);
+	struct rockchip_drm_display *display = rockchip_encoder->display;
+
+	if (display->ops->dpms)
+		display->ops->dpms(display, DRM_MODE_DPMS_ON);
+
+	if (display->ops->commit)
+		display->ops->commit(display);
+}
+
+static void rockchip_drm_encoder_disable(struct drm_encoder *encoder)
+{
+	struct drm_plane *plane;
+	struct drm_device *dev = encoder->dev;
+
+	rockchip_drm_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+
+	/* all planes connected to this encoder should be also disabled. */
+	drm_for_each_legacy_plane(plane, &dev->mode_config.plane_list) {
+		if (plane->crtc == encoder->crtc)
+			plane->funcs->disable_plane(plane);
+	}
+}
+
+static struct drm_encoder_helper_funcs rockchip_encoder_helper_funcs = {
+	.dpms = rockchip_drm_encoder_dpms,
+	.mode_fixup = rockchip_drm_encoder_mode_fixup,
+	.mode_set = rockchip_drm_encoder_mode_set,
+	.prepare = rockchip_drm_encoder_prepare,
+	.commit = rockchip_drm_encoder_commit,
+	.disable = rockchip_drm_encoder_disable,
+};
+
+static void rockchip_drm_encoder_destroy(struct drm_encoder *encoder)
+{
+	struct rockchip_drm_encoder *rockchip_encoder =
+						to_rockchip_encoder(encoder);
+
+	drm_encoder_cleanup(encoder);
+	kfree(rockchip_encoder);
+}
+
+static struct drm_encoder_funcs rockchip_encoder_funcs = {
+	.destroy = rockchip_drm_encoder_destroy,
+};
+
+static unsigned int rockchip_drm_encoder_clones(struct drm_encoder *encoder)
+{
+	struct drm_encoder *clone;
+	struct drm_device *dev = encoder->dev;
+	struct rockchip_drm_encoder *rockchip_encoder =
+						to_rockchip_encoder(encoder);
+	struct rockchip_drm_display *display = rockchip_encoder->display;
+	unsigned int clone_mask = 0;
+	int cnt = 0;
+
+	list_for_each_entry(clone, &dev->mode_config.encoder_list, head) {
+		switch (display->type) {
+		case ROCKCHIP_DISPLAY_TYPE_LCD:
+		case ROCKCHIP_DISPLAY_TYPE_HDMI:
+			clone_mask |= (1 << (cnt++));
+			break;
+		default:
+			continue;
+		}
+	}
+
+	return clone_mask;
+}
+
+void rockchip_drm_encoder_setup(struct drm_device *dev)
+{
+	struct drm_encoder *encoder;
+
+	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head)
+		encoder->possible_clones =
+				rockchip_drm_encoder_clones(encoder);
+}
+
+struct drm_encoder *rockchip_drm_encoder_create(struct drm_device *dev,
+					struct rockchip_drm_display *display,
+					unsigned long possible_crtcs)
+{
+	struct drm_encoder *encoder;
+	struct rockchip_drm_encoder *rockchip_encoder;
+
+	if (!possible_crtcs)
+		return NULL;
+
+	rockchip_encoder = kzalloc(sizeof(*rockchip_encoder), GFP_KERNEL);
+	if (!rockchip_encoder)
+		return NULL;
+
+	rockchip_encoder->display = display;
+	encoder = &rockchip_encoder->drm_encoder;
+	encoder->possible_crtcs = possible_crtcs;
+
+	DRM_DEBUG_KMS("possible_crtcs = 0x%x\n", encoder->possible_crtcs);
+
+	drm_encoder_init(dev, encoder, &rockchip_encoder_funcs,
+			DRM_MODE_ENCODER_TMDS);
+
+	drm_encoder_helper_add(encoder, &rockchip_encoder_helper_funcs);
+
+	DRM_DEBUG_KMS("encoder has been created\n");
+
+	return encoder;
+}
+
+struct rockchip_drm_display *
+		rockchip_drm_get_display(struct drm_encoder *encoder)
+{
+	return to_rockchip_encoder(encoder)->display;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_encoder.h b/drivers/gpu/drm/rockchip/rockchip_drm_encoder.h
new file mode 100644
index 0000000..38b7dc0
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_encoder.h
@@ -0,0 +1,30 @@
+/* rockchip_drm_encoder.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_encoder.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_ENCODER_H_
+#define _ROCKCHIP_DRM_ENCODER_H_
+
+struct rockchip_drm_manager;
+
+void rockchip_drm_encoder_setup(struct drm_device *dev);
+struct drm_encoder *rockchip_drm_encoder_create(struct drm_device *dev,
+			struct rockchip_drm_display *mgr,
+			unsigned long possible_crtcs);
+struct rockchip_drm_display *
+		rockchip_drm_get_display(struct drm_encoder *encoder);
+
+#endif /* _ROCKCHIP_DRM_ENCODER_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
new file mode 100644
index 0000000..ca27d74
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -0,0 +1,333 @@
+/* rockchip_drm_fb.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fb.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_helper.h>
+#include <uapi/drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_fb.h"
+#include "rockchip_drm_fbdev.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_iommu.h"
+#include "rockchip_drm_crtc.h"
+
+#define to_rockchip_fb(x) container_of(x, struct rockchip_drm_fb, fb)
+
+/*
+ * rockchip specific framebuffer structure.
+ *
+ * @fb: drm framebuffer obejct.
+ * @buf_cnt: a buffer count to drm framebuffer.
+ * @rockchip_gem_obj: array of rockchip specific
+ *                    gem object containing a gem object.
+ */
+struct rockchip_drm_fb {
+	struct drm_framebuffer fb;
+	unsigned int buf_cnt;
+	struct rockchip_drm_gem_obj *rockchip_gem_obj[MAX_FB_BUFFER];
+};
+
+static int check_fb_gem_memory_type(struct drm_device *drm_dev,
+				struct rockchip_drm_gem_obj *rockchip_gem_obj)
+{
+	unsigned int flags;
+
+	/*
+	 * if rockchip drm driver supports iommu then framebuffer can use
+	 * all the buffer types.
+	 */
+	if (is_drm_iommu_supported(drm_dev))
+		return 0;
+
+	flags = rockchip_gem_obj->flags;
+
+	/*
+	 * without iommu support, not support physically non-continuous memory
+	 * for framebuffer.
+	 */
+	if (IS_NONCONTIG_BUFFER(flags)) {
+		DRM_ERROR("cannot use this gem memory type for fb.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void rockchip_drm_fb_destroy(struct drm_framebuffer *fb)
+{
+	struct rockchip_drm_fb *rockchip_fb = to_rockchip_fb(fb);
+	unsigned int i;
+
+	/* make sure that overlay data are updated before relesing fb. */
+	rockchip_drm_crtc_complete_scanout(fb);
+
+	drm_framebuffer_cleanup(fb);
+
+	for (i = 0; i < ARRAY_SIZE(rockchip_fb->rockchip_gem_obj); i++) {
+		struct drm_gem_object *obj;
+
+		if (rockchip_fb->rockchip_gem_obj[i] == NULL)
+			continue;
+
+		obj = &rockchip_fb->rockchip_gem_obj[i]->base;
+		drm_gem_object_unreference_unlocked(obj);
+	}
+
+	kfree(rockchip_fb);
+	rockchip_fb = NULL;
+}
+
+static int rockchip_drm_fb_create_handle(struct drm_framebuffer *fb,
+					struct drm_file *file_priv,
+					unsigned int *handle)
+{
+	struct rockchip_drm_fb *rockchip_fb = to_rockchip_fb(fb);
+
+	/* This fb should have only one gem object. */
+	if (WARN_ON(rockchip_fb->buf_cnt != 1))
+		return -EINVAL;
+
+	return drm_gem_handle_create(file_priv,
+			&rockchip_fb->rockchip_gem_obj[0]->base, handle);
+}
+
+static int rockchip_drm_fb_dirty(struct drm_framebuffer *fb,
+				struct drm_file *file_priv, unsigned flags,
+				unsigned color, struct drm_clip_rect *clips,
+				unsigned num_clips)
+{
+	/* TODO */
+
+	return 0;
+}
+
+static struct drm_framebuffer_funcs rockchip_drm_fb_funcs = {
+	.destroy = rockchip_drm_fb_destroy,
+	.create_handle = rockchip_drm_fb_create_handle,
+	.dirty = rockchip_drm_fb_dirty,
+};
+
+void rockchip_drm_fb_set_buf_cnt(struct drm_framebuffer *fb,
+						unsigned int cnt)
+{
+	struct rockchip_drm_fb *rockchip_fb;
+
+	rockchip_fb = to_rockchip_fb(fb);
+
+	rockchip_fb->buf_cnt = cnt;
+}
+
+unsigned int rockchip_drm_fb_get_buf_cnt(struct drm_framebuffer *fb)
+{
+	struct rockchip_drm_fb *rockchip_fb;
+
+	rockchip_fb = to_rockchip_fb(fb);
+
+	return rockchip_fb->buf_cnt;
+}
+
+struct drm_framebuffer *
+rockchip_drm_framebuffer_init(struct drm_device *dev,
+			    struct drm_mode_fb_cmd2 *mode_cmd,
+			    struct drm_gem_object *obj)
+{
+	struct rockchip_drm_fb *rockchip_fb;
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	int ret;
+
+	rockchip_gem_obj = to_rockchip_gem_obj(obj);
+
+	ret = check_fb_gem_memory_type(dev, rockchip_gem_obj);
+	if (ret < 0) {
+		DRM_ERROR("cannot use this gem memory type for fb.\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	rockchip_fb = kzalloc(sizeof(*rockchip_fb), GFP_KERNEL);
+	if (!rockchip_fb)
+		return ERR_PTR(-ENOMEM);
+
+	drm_helper_mode_fill_fb_struct(&rockchip_fb->fb, mode_cmd);
+	rockchip_fb->rockchip_gem_obj[0] = rockchip_gem_obj;
+
+	ret = drm_framebuffer_init(dev, &rockchip_fb->fb,
+					&rockchip_drm_fb_funcs);
+	if (ret) {
+		DRM_ERROR("failed to initialize framebuffer\n");
+		return ERR_PTR(ret);
+	}
+
+	return &rockchip_fb->fb;
+}
+
+static u32 rockchip_drm_format_num_buffers(struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	unsigned int cnt = 0;
+
+	if (mode_cmd->pixel_format != DRM_FORMAT_NV12)
+		return drm_format_num_planes(mode_cmd->pixel_format);
+
+	while (cnt != MAX_FB_BUFFER) {
+		if (!mode_cmd->handles[cnt])
+			break;
+		cnt++;
+	}
+
+	/*
+	 * check if NV12 or NV12M.
+	 *
+	 * NV12
+	 * handles[0] = base1, offsets[0] = 0
+	 * handles[1] = base1, offsets[1] = Y_size
+	 *
+	 * NV12M
+	 * handles[0] = base1, offsets[0] = 0
+	 * handles[1] = base2, offsets[1] = 0
+	 */
+	if (cnt == 2) {
+		/*
+		 * in case of NV12 format, offsets[1] is not 0 and
+		 * handles[0] is same as handles[1].
+		 */
+		if (mode_cmd->offsets[1] &&
+			mode_cmd->handles[0] == mode_cmd->handles[1])
+			cnt = 1;
+	}
+
+	return cnt;
+}
+
+static struct drm_framebuffer *
+rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file_priv,
+		      struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	struct drm_gem_object *obj;
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct rockchip_drm_fb *rockchip_fb;
+	int i, ret;
+
+	rockchip_fb = kzalloc(sizeof(*rockchip_fb), GFP_KERNEL);
+	if (!rockchip_fb)
+		return ERR_PTR(-ENOMEM);
+
+	obj = drm_gem_object_lookup(dev, file_priv, mode_cmd->handles[0]);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object\n");
+		ret = -ENOENT;
+		goto err_free;
+	}
+
+	drm_helper_mode_fill_fb_struct(&rockchip_fb->fb, mode_cmd);
+	rockchip_fb->rockchip_gem_obj[0] = to_rockchip_gem_obj(obj);
+	rockchip_fb->buf_cnt = rockchip_drm_format_num_buffers(mode_cmd);
+
+	DRM_DEBUG_KMS("buf_cnt = %d\n", rockchip_fb->buf_cnt);
+
+	for (i = 1; i < rockchip_fb->buf_cnt; i++) {
+		obj = drm_gem_object_lookup(dev, file_priv,
+				mode_cmd->handles[i]);
+		if (!obj) {
+			DRM_ERROR("failed to lookup gem object\n");
+			ret = -ENOENT;
+			rockchip_fb->buf_cnt = i;
+			goto err_unreference;
+		}
+
+		rockchip_gem_obj = to_rockchip_gem_obj(obj);
+		rockchip_fb->rockchip_gem_obj[i] = rockchip_gem_obj;
+
+		ret = check_fb_gem_memory_type(dev, rockchip_gem_obj);
+		if (ret < 0) {
+			DRM_ERROR("cannot use this gem memory type for fb.\n");
+			goto err_unreference;
+		}
+	}
+
+	ret = drm_framebuffer_init(dev, &rockchip_fb->fb,
+					&rockchip_drm_fb_funcs);
+	if (ret) {
+		DRM_ERROR("failed to init framebuffer.\n");
+		goto err_unreference;
+	}
+
+	return &rockchip_fb->fb;
+
+err_unreference:
+	for (i = 0; i < rockchip_fb->buf_cnt; i++) {
+		struct drm_gem_object *obj;
+
+		obj = &rockchip_fb->rockchip_gem_obj[i]->base;
+		if (obj)
+			drm_gem_object_unreference_unlocked(obj);
+	}
+err_free:
+	kfree(rockchip_fb);
+	return ERR_PTR(ret);
+}
+
+struct rockchip_drm_gem_buf *rockchip_drm_fb_buffer(struct drm_framebuffer *fb,
+						int index)
+{
+	struct rockchip_drm_fb *rockchip_fb = to_rockchip_fb(fb);
+	struct rockchip_drm_gem_buf *buffer;
+
+	if (index >= MAX_FB_BUFFER)
+		return NULL;
+
+	buffer = rockchip_fb->rockchip_gem_obj[index]->buffer;
+	if (!buffer)
+		return NULL;
+
+	DRM_DEBUG_KMS("dma_addr = 0x%lx\n", (unsigned long)buffer->dma_addr);
+
+	return buffer;
+}
+
+static void rockchip_drm_output_poll_changed(struct drm_device *dev)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct drm_fb_helper *fb_helper = private->fb_helper;
+
+	if (fb_helper)
+		drm_fb_helper_hotplug_event(fb_helper);
+	else
+		rockchip_drm_fbdev_init(dev);
+}
+
+static const struct drm_mode_config_funcs rockchip_drm_mode_config_funcs = {
+	.fb_create = rockchip_user_fb_create,
+	.output_poll_changed = rockchip_drm_output_poll_changed,
+};
+
+void rockchip_drm_mode_config_init(struct drm_device *dev)
+{
+	dev->mode_config.min_width = 0;
+	dev->mode_config.min_height = 0;
+
+	/*
+	 * set max width and height as default value(4096x4096).
+	 * this value would be used to check framebuffer size limitation
+	 * at drm_mode_addfb().
+	 */
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
+
+	dev->mode_config.funcs = &rockchip_drm_mode_config_funcs;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.h b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
new file mode 100644
index 0000000..1639ab20
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.h
@@ -0,0 +1,39 @@
+/* rockchip_drm_fb.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fb.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_FB_H_
+#define _ROCKCHIP_DRM_FB_H_
+
+struct drm_framebuffer *
+rockchip_drm_framebuffer_init(struct drm_device *dev,
+			    struct drm_mode_fb_cmd2 *mode_cmd,
+			    struct drm_gem_object *obj);
+
+/* get memory information of a drm framebuffer */
+struct rockchip_drm_gem_buf *rockchip_drm_fb_buffer(struct drm_framebuffer *fb,
+						 int index);
+
+void rockchip_drm_mode_config_init(struct drm_device *dev);
+
+/* set a buffer count to drm framebuffer. */
+void rockchip_drm_fb_set_buf_cnt(struct drm_framebuffer *fb,
+						unsigned int cnt);
+
+/* get a buffer count to drm framebuffer. */
+unsigned int rockchip_drm_fb_get_buf_cnt(struct drm_framebuffer *fb);
+
+#endif /* _ROCKCHIP_DRM_FB_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
new file mode 100644
index 0000000..49f41a9
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
@@ -0,0 +1,380 @@
+/* rockchip_drm_fbdev.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fbdev.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_fb_helper.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_fb.h"
+#include "rockchip_drm_fbdev.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_iommu.h"
+
+#define MAX_CONNECTOR		4
+#define PREFERRED_BPP		32
+
+#define to_rockchip_fbdev(x)	container_of(x, struct rockchip_drm_fbdev,\
+				drm_fb_helper)
+
+struct rockchip_drm_fbdev {
+	struct drm_fb_helper drm_fb_helper;
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+};
+
+static int rockchip_drm_fb_mmap(struct fb_info *info,
+			struct vm_area_struct *vma)
+{
+	struct drm_fb_helper *helper = info->par;
+	struct rockchip_drm_fbdev *rockchip_fbd = to_rockchip_fbdev(helper);
+	struct rockchip_drm_gem_obj *rockchip_gem_obj =
+					rockchip_fbd->rockchip_gem_obj;
+	struct rockchip_drm_gem_buf *buffer = rockchip_gem_obj->buffer;
+	unsigned long vm_size;
+	int ret;
+
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
+
+	vm_size = vma->vm_end - vma->vm_start;
+
+	if (vm_size > buffer->size)
+		return -EINVAL;
+
+	ret = dma_mmap_attrs(helper->dev->dev, vma, buffer->pages,
+		buffer->dma_addr, buffer->size, &buffer->dma_attrs);
+	if (ret < 0) {
+		DRM_ERROR("failed to mmap.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct fb_ops rockchip_drm_fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_mmap = rockchip_drm_fb_mmap,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_check_var = drm_fb_helper_check_var,
+	.fb_set_par = drm_fb_helper_set_par,
+	.fb_blank = drm_fb_helper_blank,
+	.fb_pan_display = drm_fb_helper_pan_display,
+	.fb_setcmap = drm_fb_helper_setcmap,
+};
+
+static int rockchip_drm_fbdev_update(struct drm_fb_helper *helper,
+				     struct drm_framebuffer *fb)
+{
+	struct fb_info *fbi = helper->fbdev;
+	struct drm_device *dev = helper->dev;
+	struct rockchip_drm_gem_buf *buffer;
+	unsigned int size = fb->width * fb->height * (fb->bits_per_pixel >> 3);
+	unsigned long offset;
+
+	drm_fb_helper_fill_fix(fbi, fb->pitches[0], fb->depth);
+	drm_fb_helper_fill_var(fbi, helper, fb->width, fb->height);
+
+	/* RGB formats use only one buffer */
+	buffer = rockchip_drm_fb_buffer(fb, 0);
+	if (!buffer) {
+		DRM_DEBUG_KMS("buffer is null.\n");
+		return -EFAULT;
+	}
+
+	/* map pages with kernel virtual space. */
+	if (!buffer->kvaddr) {
+		if (is_drm_iommu_supported(dev)) {
+			unsigned int nr_pages = buffer->size >> PAGE_SHIFT;
+
+			buffer->kvaddr = (void __iomem *) vmap(buffer->pages,
+					nr_pages, VM_MAP,
+					pgprot_writecombine(PAGE_KERNEL));
+		} else {
+			phys_addr_t dma_addr = buffer->dma_addr;
+
+			if (dma_addr)
+				buffer->kvaddr =
+					(void __iomem *)phys_to_virt(dma_addr);
+			else
+				buffer->kvaddr = (void __iomem *)NULL;
+		}
+		if (!buffer->kvaddr) {
+			DRM_ERROR("failed to map pages to kernel space.\n");
+			return -EIO;
+		}
+	}
+
+	/* buffer count to framebuffer always is 1 at booting time. */
+	rockchip_drm_fb_set_buf_cnt(fb, 1);
+
+	offset = fbi->var.xoffset * (fb->bits_per_pixel >> 3);
+	offset += fbi->var.yoffset * fb->pitches[0];
+
+	fbi->screen_base = buffer->kvaddr + offset;
+	fbi->screen_size = size;
+	fbi->fix.smem_len = size;
+
+	return 0;
+}
+
+static int rockchip_drm_fbdev_create(struct drm_fb_helper *helper,
+				    struct drm_fb_helper_surface_size *sizes)
+{
+	struct rockchip_drm_fbdev *rockchip_fbdev = to_rockchip_fbdev(helper);
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct drm_device *dev = helper->dev;
+	struct fb_info *fbi;
+	struct drm_mode_fb_cmd2 mode_cmd = { 0 };
+	struct platform_device *pdev = dev->platformdev;
+	unsigned long size;
+	int ret;
+
+	DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d\n",
+			sizes->surface_width, sizes->surface_height,
+			sizes->surface_bpp);
+
+	mode_cmd.width = sizes->surface_width;
+	mode_cmd.height = sizes->surface_height;
+	mode_cmd.pitches[0] = sizes->surface_width * (sizes->surface_bpp >> 3);
+	mode_cmd.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
+							  sizes->surface_depth);
+
+	mutex_lock(&dev->struct_mutex);
+
+	fbi = framebuffer_alloc(0, &pdev->dev);
+	if (!fbi) {
+		DRM_ERROR("failed to allocate fb info.\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	size = mode_cmd.pitches[0] * mode_cmd.height;
+
+	rockchip_gem_obj = rockchip_drm_gem_create(dev,
+						ROCKCHIP_BO_CONTIG, size);
+	/*
+	 * If physically contiguous memory allocation fails and if IOMMU is
+	 * supported then try to get buffer from non physically contiguous
+	 * memory area.
+	 */
+	if (IS_ERR(rockchip_gem_obj) && is_drm_iommu_supported(dev)) {
+		dev_warn(&pdev->dev, "contiguous FB allocation failed, falling back to non-contiguous\n");
+		rockchip_gem_obj = rockchip_drm_gem_create(dev,
+					ROCKCHIP_BO_NONCONTIG, size);
+	}
+
+	if (IS_ERR(rockchip_gem_obj)) {
+		ret = PTR_ERR(rockchip_gem_obj);
+		goto err_release_framebuffer;
+	}
+
+	rockchip_fbdev->rockchip_gem_obj = rockchip_gem_obj;
+
+	helper->fb = rockchip_drm_framebuffer_init(dev, &mode_cmd,
+			&rockchip_gem_obj->base);
+	if (IS_ERR(helper->fb)) {
+		DRM_ERROR("failed to create drm framebuffer.\n");
+		ret = PTR_ERR(helper->fb);
+		goto err_destroy_gem;
+	}
+
+	helper->fbdev = fbi;
+
+	fbi->par = helper;
+	fbi->flags = FBINFO_FLAG_DEFAULT;
+	fbi->fbops = &rockchip_drm_fb_ops;
+
+	ret = fb_alloc_cmap(&fbi->cmap, 256, 0);
+	if (ret) {
+		DRM_ERROR("failed to allocate cmap.\n");
+		goto err_destroy_framebuffer;
+	}
+
+	ret = rockchip_drm_fbdev_update(helper, helper->fb);
+	if (ret < 0)
+		goto err_dealloc_cmap;
+
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+
+err_dealloc_cmap:
+	fb_dealloc_cmap(&fbi->cmap);
+err_destroy_framebuffer:
+	drm_framebuffer_cleanup(helper->fb);
+err_destroy_gem:
+	rockchip_drm_gem_destroy(rockchip_gem_obj);
+err_release_framebuffer:
+	framebuffer_release(fbi);
+
+/*
+ * if failed, all resources allocated above would be released by
+ * drm_mode_config_cleanup() when drm_load() had been called prior
+ * to any specific driver such as lcdc or hdmi driver.
+ */
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+static struct drm_fb_helper_funcs rockchip_drm_fb_helper_funcs = {
+	.fb_probe = rockchip_drm_fbdev_create,
+};
+
+static bool rockchip_drm_fbdev_is_anything_connected(struct drm_device *dev)
+{
+	struct drm_connector *connector;
+	bool ret = false;
+
+	mutex_lock(&dev->mode_config.mutex);
+	list_for_each_entry(connector,
+			&dev->mode_config.connector_list, head) {
+		if (connector->status != connector_status_connected)
+			continue;
+
+		ret = true;
+		break;
+	}
+	mutex_unlock(&dev->mode_config.mutex);
+
+	return ret;
+}
+
+int rockchip_drm_fbdev_init(struct drm_device *dev)
+{
+	struct rockchip_drm_fbdev *fbdev;
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct drm_fb_helper *helper;
+	unsigned int num_crtc;
+	int ret;
+
+	if (!dev->mode_config.num_crtc || !dev->mode_config.num_connector)
+		return 0;
+
+	if (!rockchip_drm_fbdev_is_anything_connected(dev))
+		return 0;
+
+	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);
+	if (!fbdev)
+		return -ENOMEM;
+
+	private->fb_helper = helper = &fbdev->drm_fb_helper;
+	helper->funcs = &rockchip_drm_fb_helper_funcs;
+
+	num_crtc = dev->mode_config.num_crtc;
+
+	ret = drm_fb_helper_init(dev, helper, num_crtc, MAX_CONNECTOR);
+	if (ret < 0) {
+		DRM_ERROR("failed to initialize drm fb helper.\n");
+		goto err_init;
+	}
+
+	ret = drm_fb_helper_single_add_all_connectors(helper);
+	if (ret < 0) {
+		DRM_ERROR("failed to register drm_fb_helper_connector.\n");
+		goto err_setup;
+	}
+
+	/* disable all the possible outputs/crtcs before entering KMS mode */
+	drm_helper_disable_unused_functions(dev);
+
+	ret = drm_fb_helper_initial_config(helper, PREFERRED_BPP);
+	if (ret < 0) {
+		DRM_ERROR("failed to set up hw configuration.\n");
+		goto err_setup;
+	}
+
+	return 0;
+
+err_setup:
+	drm_fb_helper_fini(helper);
+
+err_init:
+	private->fb_helper = NULL;
+	kfree(fbdev);
+
+	return ret;
+}
+
+static void rockchip_drm_fbdev_destroy(struct drm_device *dev,
+				      struct drm_fb_helper *fb_helper)
+{
+	struct rockchip_drm_fbdev *rockchip_fbd = to_rockchip_fbdev(fb_helper);
+	struct rockchip_drm_gem_obj *rockchip_gem_obj =
+						rockchip_fbd->rockchip_gem_obj;
+	struct drm_framebuffer *fb;
+
+	if (is_drm_iommu_supported(dev) && rockchip_gem_obj->buffer->kvaddr)
+		vunmap(rockchip_gem_obj->buffer->kvaddr);
+
+	/* release drm framebuffer and real buffer */
+	if (fb_helper->fb && fb_helper->fb->funcs) {
+		fb = fb_helper->fb;
+		if (fb) {
+			drm_framebuffer_unregister_private(fb);
+			drm_framebuffer_remove(fb);
+		}
+	}
+
+	/* release linux framebuffer */
+	if (fb_helper->fbdev) {
+		struct fb_info *info;
+		int ret;
+
+		info = fb_helper->fbdev;
+		ret = unregister_framebuffer(info);
+		if (ret < 0)
+			DRM_DEBUG_KMS("failed unregister_framebuffer()\n");
+
+		if (info->cmap.len)
+			fb_dealloc_cmap(&info->cmap);
+
+		framebuffer_release(info);
+	}
+
+	drm_fb_helper_fini(fb_helper);
+}
+
+void rockchip_drm_fbdev_fini(struct drm_device *dev)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+	struct rockchip_drm_fbdev *fbdev;
+
+	if (!private || !private->fb_helper)
+		return;
+
+	fbdev = to_rockchip_fbdev(private->fb_helper);
+
+	if (fbdev->rockchip_gem_obj)
+		rockchip_drm_gem_destroy(fbdev->rockchip_gem_obj);
+
+	rockchip_drm_fbdev_destroy(dev, private->fb_helper);
+	kfree(fbdev);
+	private->fb_helper = NULL;
+}
+
+void rockchip_drm_fbdev_restore_mode(struct drm_device *dev)
+{
+	struct rockchip_drm_private *private = dev->dev_private;
+
+	if (!private || !private->fb_helper)
+		return;
+
+	drm_fb_helper_restore_fbdev_mode_unlocked(private->fb_helper);
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
new file mode 100644
index 0000000..d4bda37
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
@@ -0,0 +1,26 @@
+/* rockchip_drm_fbdev.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_fbdev.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_FBDEV_H_
+#define _ROCKCHIP_DRM_FBDEV_H_
+
+int rockchip_drm_fbdev_init(struct drm_device *dev);
+int rockchip_drm_fbdev_reinit(struct drm_device *dev);
+void rockchip_drm_fbdev_fini(struct drm_device *dev);
+void rockchip_drm_fbdev_restore_mode(struct drm_device *dev);
+
+#endif /* _ROCKCHIP_DRM_FBDEV_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
new file mode 100644
index 0000000..96116d9
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -0,0 +1,738 @@
+/* rockchip_drm_gem.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_gem.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_vma_manager.h>
+
+#include <linux/shmem_fs.h>
+#include <drm/rockchip_drm.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_buf.h"
+#include "rockchip_drm_iommu.h"
+
+static unsigned int convert_to_vm_err_msg(int msg)
+{
+	unsigned int out_msg;
+
+	switch (msg) {
+	case 0:
+	case -ERESTARTSYS:
+	case -EINTR:
+		out_msg = VM_FAULT_NOPAGE;
+		break;
+
+	case -ENOMEM:
+		out_msg = VM_FAULT_OOM;
+		break;
+	default:
+		out_msg = VM_FAULT_SIGBUS;
+		break;
+	}
+
+	return out_msg;
+}
+
+static int check_gem_flags(unsigned int flags)
+{
+	if (flags & ~(ROCKCHIP_BO_MASK)) {
+		DRM_ERROR("invalid flags.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void update_vm_cache_attr(struct rockchip_drm_gem_obj *obj,
+					struct vm_area_struct *vma)
+{
+	DRM_DEBUG_KMS("flags = 0x%x\n", obj->flags);
+
+	/* non-cachable as default. */
+	if (obj->flags & ROCKCHIP_BO_CACHABLE)
+		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	else if (obj->flags & ROCKCHIP_BO_WC)
+		vma->vm_page_prot =
+			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	else
+		vma->vm_page_prot =
+			pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+}
+
+static unsigned long roundup_gem_size(unsigned long size, unsigned int flags)
+{
+	/* TODO */
+
+	return roundup(size, PAGE_SIZE);
+}
+
+static int rockchip_drm_gem_map_buf(struct drm_gem_object *obj,
+					struct vm_area_struct *vma,
+					unsigned long f_vaddr,
+					pgoff_t page_offset)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj =
+						to_rockchip_gem_obj(obj);
+	struct rockchip_drm_gem_buf *buf = rockchip_gem_obj->buffer;
+	struct scatterlist *sgl;
+	unsigned long pfn;
+	int i;
+
+	if (!buf->sgt)
+		return -EINTR;
+
+	if (page_offset >= (buf->size >> PAGE_SHIFT)) {
+		DRM_ERROR("invalid page offset\n");
+		return -EINVAL;
+	}
+
+	sgl = buf->sgt->sgl;
+	for_each_sg(buf->sgt->sgl, sgl, buf->sgt->nents, i) {
+		if (page_offset < (sgl->length >> PAGE_SHIFT))
+			break;
+		page_offset -= (sgl->length >> PAGE_SHIFT);
+	}
+
+	pfn = __phys_to_pfn(sg_phys(sgl)) + page_offset;
+
+	return vm_insert_mixed(vma, f_vaddr, pfn);
+}
+
+static int rockchip_drm_gem_handle_create(struct drm_gem_object *obj,
+					struct drm_file *file_priv,
+					unsigned int *handle)
+{
+	int ret;
+
+	/*
+	 * allocate a id of idr table where the obj is registered
+	 * and handle has the id what user can see.
+	 */
+	ret = drm_gem_handle_create(file_priv, obj, handle);
+	if (ret)
+		return ret;
+
+	DRM_DEBUG_KMS("gem handle = 0x%x\n", *handle);
+
+	/* drop reference from allocate - handle holds it now. */
+	drm_gem_object_unreference_unlocked(obj);
+
+	return 0;
+}
+
+void rockchip_drm_gem_destroy(struct rockchip_drm_gem_obj *rockchip_gem_obj)
+{
+	struct drm_gem_object *obj;
+	struct rockchip_drm_gem_buf *buf;
+
+	obj = &rockchip_gem_obj->base;
+	buf = rockchip_gem_obj->buffer;
+
+	DRM_DEBUG_KMS("handle count = %d\n", obj->handle_count);
+
+	/*
+	 * do not release memory region from exporter.
+	 *
+	 * the region will be released by exporter
+	 * once dmabuf's refcount becomes 0.
+	 */
+	if (obj->import_attach)
+		goto out;
+
+	rockchip_drm_free_buf(obj->dev, rockchip_gem_obj->flags, buf);
+
+out:
+	rockchip_drm_fini_buf(obj->dev, buf);
+	rockchip_gem_obj->buffer = NULL;
+
+	drm_gem_free_mmap_offset(obj);
+
+	/* release file pointer to gem object. */
+	drm_gem_object_release(obj);
+
+	kfree(rockchip_gem_obj);
+	rockchip_gem_obj = NULL;
+}
+
+unsigned long rockchip_drm_gem_get_size(struct drm_device *dev,
+						unsigned int gem_handle,
+						struct drm_file *file_priv)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct drm_gem_object *obj;
+
+	obj = drm_gem_object_lookup(dev, file_priv, gem_handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		return 0;
+	}
+
+	rockchip_gem_obj = to_rockchip_gem_obj(obj);
+
+	drm_gem_object_unreference_unlocked(obj);
+
+	return rockchip_gem_obj->buffer->size;
+}
+
+
+struct rockchip_drm_gem_obj *rockchip_drm_gem_init(struct drm_device *dev,
+						      unsigned long size)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct drm_gem_object *obj;
+	int ret;
+
+	rockchip_gem_obj = kzalloc(sizeof(*rockchip_gem_obj), GFP_KERNEL);
+	if (!rockchip_gem_obj)
+		return NULL;
+
+	rockchip_gem_obj->size = size;
+	obj = &rockchip_gem_obj->base;
+
+	ret = drm_gem_object_init(dev, obj, size);
+	if (ret < 0) {
+		DRM_ERROR("failed to initialize gem object\n");
+		kfree(rockchip_gem_obj);
+		return NULL;
+	}
+
+	DRM_DEBUG_KMS("created file object = 0x%x\n", (unsigned int)obj->filp);
+
+	return rockchip_gem_obj;
+}
+
+struct rockchip_drm_gem_obj *rockchip_drm_gem_create(struct drm_device *dev,
+						unsigned int flags,
+						unsigned long size)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct rockchip_drm_gem_buf *buf;
+	int ret;
+
+	if (!size) {
+		DRM_ERROR("invalid size.\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	size = roundup_gem_size(size, flags);
+
+	ret = check_gem_flags(flags);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	buf = rockchip_drm_init_buf(dev, size);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	rockchip_gem_obj = rockchip_drm_gem_init(dev, size);
+	if (!rockchip_gem_obj) {
+		ret = -ENOMEM;
+		goto err_fini_buf;
+	}
+
+	rockchip_gem_obj->buffer = buf;
+
+	/* set memory type and cache attribute from user side. */
+	rockchip_gem_obj->flags = flags;
+
+	ret = rockchip_drm_alloc_buf(dev, buf, flags);
+	if (ret < 0)
+		goto err_gem_fini;
+
+	return rockchip_gem_obj;
+
+err_gem_fini:
+	drm_gem_object_release(&rockchip_gem_obj->base);
+	kfree(rockchip_gem_obj);
+err_fini_buf:
+	rockchip_drm_fini_buf(dev, buf);
+	return ERR_PTR(ret);
+}
+
+int rockchip_drm_gem_create_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv)
+{
+	struct drm_rockchip_gem_create *args = data;
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	int ret;
+
+	rockchip_gem_obj = rockchip_drm_gem_create(dev,
+					args->flags, args->size);
+	if (IS_ERR(rockchip_gem_obj))
+		return PTR_ERR(rockchip_gem_obj);
+
+	ret = rockchip_drm_gem_handle_create(&rockchip_gem_obj->base,
+					file_priv, &args->handle);
+	if (ret) {
+		rockchip_drm_gem_destroy(rockchip_gem_obj);
+		return ret;
+	}
+
+	return 0;
+}
+
+dma_addr_t *rockchip_drm_gem_get_dma_addr(struct drm_device *dev,
+					unsigned int gem_handle,
+					struct drm_file *filp)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct drm_gem_object *obj;
+
+	obj = drm_gem_object_lookup(dev, filp, gem_handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	rockchip_gem_obj = to_rockchip_gem_obj(obj);
+
+	return &rockchip_gem_obj->buffer->dma_addr;
+}
+
+void rockchip_drm_gem_put_dma_addr(struct drm_device *dev,
+					unsigned int gem_handle,
+					struct drm_file *filp)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct drm_gem_object *obj;
+
+	obj = drm_gem_object_lookup(dev, filp, gem_handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		return;
+	}
+
+	rockchip_gem_obj = to_rockchip_gem_obj(obj);
+
+	drm_gem_object_unreference_unlocked(obj);
+
+	/*
+	 * decrease obj->refcount one more time because we has already
+	 * increased it at rockchip_drm_gem_get_dma_addr().
+	 */
+	drm_gem_object_unreference_unlocked(obj);
+}
+
+int rockchip_drm_gem_map_offset_ioctl(struct drm_device *dev, void *data,
+				    struct drm_file *file_priv)
+{
+	struct drm_rockchip_gem_map_off *args = data;
+
+	DRM_DEBUG_KMS("handle = 0x%x, offset = 0x%lx\n",
+			args->handle, (unsigned long)args->offset);
+
+	if (!(dev->driver->driver_features & DRIVER_GEM)) {
+		DRM_ERROR("does not support GEM.\n");
+		return -ENODEV;
+	}
+
+	return rockchip_drm_gem_dumb_map_offset(file_priv, dev, args->handle,
+			&args->offset);
+}
+
+int rockchip_drm_gem_mmap_buffer(struct file *filp,
+				      struct vm_area_struct *vma)
+{
+	struct drm_gem_object *obj = filp->private_data;
+	struct rockchip_drm_gem_obj *rockchip_gem_obj =
+						to_rockchip_gem_obj(obj);
+	struct drm_device *drm_dev = obj->dev;
+	struct rockchip_drm_gem_buf *buffer;
+	unsigned long vm_size;
+	int ret;
+
+	WARN_ON(!mutex_is_locked(&obj->dev->struct_mutex));
+
+	vma->vm_flags |= VM_IO | VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_private_data = obj;
+	vma->vm_ops = drm_dev->driver->gem_vm_ops;
+
+	update_vm_cache_attr(rockchip_gem_obj, vma);
+
+	vm_size = vma->vm_end - vma->vm_start;
+
+	/*
+	 * a buffer contains information to physically continuous memory
+	 * allocated by user request or at framebuffer creation.
+	 */
+	buffer = rockchip_gem_obj->buffer;
+
+	/* check if user-requested size is valid. */
+	if (vm_size > buffer->size)
+		return -EINVAL;
+
+	ret = dma_mmap_attrs(drm_dev->dev, vma, buffer->pages,
+				buffer->dma_addr, buffer->size,
+				&buffer->dma_attrs);
+	if (ret < 0) {
+		DRM_ERROR("failed to mmap.\n");
+		return ret;
+	}
+
+	/*
+	 * take a reference to this mapping of the object. And this reference
+	 * is unreferenced by the corresponding vm_close call.
+	 */
+	drm_gem_object_reference(obj);
+
+	drm_vm_open_locked(drm_dev, vma);
+
+	return 0;
+}
+
+int rockchip_drm_gem_mmap_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv)
+{
+	struct drm_rockchip_file_private *rockchip_file_priv;
+	struct drm_rockchip_gem_mmap *args = data;
+	struct drm_gem_object *obj;
+	struct file *anon_filp;
+	unsigned long addr;
+
+	if (!(dev->driver->driver_features & DRIVER_GEM)) {
+		DRM_ERROR("does not support GEM.\n");
+		return -ENODEV;
+	}
+
+	mutex_lock(&dev->struct_mutex);
+
+	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		mutex_unlock(&dev->struct_mutex);
+		return -EINVAL;
+	}
+
+	rockchip_file_priv = file_priv->driver_priv;
+	anon_filp = rockchip_file_priv->anon_filp;
+	anon_filp->private_data = obj;
+
+	addr = vm_mmap(anon_filp, 0, args->size, PROT_READ | PROT_WRITE,
+			MAP_SHARED, 0);
+
+	drm_gem_object_unreference(obj);
+
+	if (IS_ERR_VALUE(addr)) {
+		mutex_unlock(&dev->struct_mutex);
+		return (int)addr;
+	}
+
+	mutex_unlock(&dev->struct_mutex);
+
+	args->mapped = addr;
+
+	DRM_DEBUG_KMS("mapped = 0x%lx\n", (unsigned long)args->mapped);
+
+	return 0;
+}
+
+int rockchip_drm_gem_get_ioctl(struct drm_device *dev, void *data,
+				      struct drm_file *file_priv)
+{	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct drm_rockchip_gem_info *args = data;
+	struct drm_gem_object *obj;
+
+	mutex_lock(&dev->struct_mutex);
+
+	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		mutex_unlock(&dev->struct_mutex);
+		return -EINVAL;
+	}
+
+	rockchip_gem_obj = to_rockchip_gem_obj(obj);
+
+	args->flags = rockchip_gem_obj->flags;
+	args->size = rockchip_gem_obj->size;
+
+	drm_gem_object_unreference(obj);
+	mutex_unlock(&dev->struct_mutex);
+
+	return 0;
+}
+
+struct vm_area_struct *rockchip_gem_get_vma(struct vm_area_struct *vma)
+{
+	struct vm_area_struct *vma_copy;
+
+	vma_copy = kmalloc(sizeof(*vma_copy), GFP_KERNEL);
+	if (!vma_copy)
+		return NULL;
+
+	if (vma->vm_ops && vma->vm_ops->open)
+		vma->vm_ops->open(vma);
+
+	if (vma->vm_file)
+		get_file(vma->vm_file);
+
+	memcpy(vma_copy, vma, sizeof(*vma));
+
+	vma_copy->vm_mm = NULL;
+	vma_copy->vm_next = NULL;
+	vma_copy->vm_prev = NULL;
+
+	return vma_copy;
+}
+
+void rockchip_gem_put_vma(struct vm_area_struct *vma)
+{
+	if (!vma)
+		return;
+
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
+
+	if (vma->vm_file)
+		fput(vma->vm_file);
+
+	kfree(vma);
+}
+
+int rockchip_gem_get_pages_from_userptr(unsigned long start,
+						unsigned int npages,
+						struct page **pages,
+						struct vm_area_struct *vma)
+{
+	int get_npages;
+
+	/* the memory region mmaped with VM_PFNMAP. */
+	if (vma_is_io(vma)) {
+		unsigned int i;
+
+		for (i = 0; i < npages; ++i, start += PAGE_SIZE) {
+			unsigned long pfn;
+			int ret = follow_pfn(vma, start, &pfn);
+
+			if (ret)
+				return ret;
+
+			pages[i] = pfn_to_page(pfn);
+		}
+
+		if (i != npages) {
+			DRM_ERROR("failed to get user_pages.\n");
+			return -EINVAL;
+		}
+
+		return 0;
+	}
+
+	get_npages = get_user_pages(current, current->mm, start,
+					npages, 1, 1, pages, NULL);
+	get_npages = max(get_npages, 0);
+	if (get_npages != npages) {
+		DRM_ERROR("failed to get user_pages.\n");
+		while (get_npages)
+			put_page(pages[--get_npages]);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+void rockchip_gem_put_pages_to_userptr(struct page **pages,
+					unsigned int npages,
+					struct vm_area_struct *vma)
+{
+	if (!vma_is_io(vma)) {
+		unsigned int i;
+
+		for (i = 0; i < npages; i++) {
+			set_page_dirty_lock(pages[i]);
+
+			/*
+			 * undo the reference we took when populating
+			 * the table.
+			 */
+			put_page(pages[i]);
+		}
+	}
+}
+
+int rockchip_gem_map_sgt_with_dma(struct drm_device *drm_dev,
+				struct sg_table *sgt,
+				enum dma_data_direction dir)
+{
+	int nents;
+
+	mutex_lock(&drm_dev->struct_mutex);
+
+	nents = dma_map_sg(drm_dev->dev, sgt->sgl, sgt->nents, dir);
+	if (!nents) {
+		DRM_ERROR("failed to map sgl with dma.\n");
+		mutex_unlock(&drm_dev->struct_mutex);
+		return nents;
+	}
+
+	mutex_unlock(&drm_dev->struct_mutex);
+
+	return 0;
+}
+
+void rockchip_gem_unmap_sgt_from_dma(struct drm_device *drm_dev,
+				struct sg_table *sgt,
+				enum dma_data_direction dir)
+{
+	dma_unmap_sg(drm_dev->dev, sgt->sgl, sgt->nents, dir);
+}
+
+void rockchip_drm_gem_free_object(struct drm_gem_object *obj)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct rockchip_drm_gem_buf *buf;
+
+	rockchip_gem_obj = to_rockchip_gem_obj(obj);
+	buf = rockchip_gem_obj->buffer;
+
+	if (obj->import_attach)
+		drm_prime_gem_destroy(obj, buf->sgt);
+
+	rockchip_drm_gem_destroy(to_rockchip_gem_obj(obj));
+}
+
+int rockchip_drm_gem_dumb_create(struct drm_file *file_priv,
+			       struct drm_device *dev,
+			       struct drm_mode_create_dumb *args)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	int ret;
+
+	/*
+	 * allocate memory to be used for framebuffer.
+	 * - this callback would be called by user application
+	 * with DRM_IOCTL_MODE_CREATE_DUMB command.
+	 */
+
+	args->pitch = args->width * ((args->bpp + 7) / 8);
+	args->size = args->pitch * args->height;
+
+	if (is_drm_iommu_supported(dev)) {
+		rockchip_gem_obj = rockchip_drm_gem_create(dev,
+			ROCKCHIP_BO_NONCONTIG | ROCKCHIP_BO_WC,
+			args->size);
+	} else {
+		rockchip_gem_obj = rockchip_drm_gem_create(dev,
+			ROCKCHIP_BO_CONTIG | ROCKCHIP_BO_WC,
+			args->size);
+	}
+
+	if (IS_ERR(rockchip_gem_obj)) {
+		dev_warn(dev->dev, "FB allocation failed.\n");
+		return PTR_ERR(rockchip_gem_obj);
+	}
+
+	ret = rockchip_drm_gem_handle_create(&rockchip_gem_obj->base,
+					file_priv, &args->handle);
+	if (ret) {
+		rockchip_drm_gem_destroy(rockchip_gem_obj);
+		return ret;
+	}
+
+	return 0;
+}
+
+int rockchip_drm_gem_dumb_map_offset(struct drm_file *file_priv,
+				   struct drm_device *dev, uint32_t handle,
+				   uint64_t *offset)
+{
+	struct drm_gem_object *obj;
+	int ret = 0;
+
+	mutex_lock(&dev->struct_mutex);
+
+	/*
+	 * get offset of memory allocated for drm framebuffer.
+	 * - this callback would be called by user application
+	 * with DRM_IOCTL_MODE_MAP_DUMB command.
+	 */
+
+	obj = drm_gem_object_lookup(dev, file_priv, handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = drm_gem_create_mmap_offset(obj);
+	if (ret)
+		goto out;
+
+	*offset = drm_vma_node_offset_addr(&obj->vma_node);
+	DRM_DEBUG_KMS("offset = 0x%lx\n", (unsigned long)*offset);
+
+out:
+	drm_gem_object_unreference(obj);
+unlock:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+int rockchip_drm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct drm_gem_object *obj = vma->vm_private_data;
+	struct drm_device *dev = obj->dev;
+	unsigned long f_vaddr;
+	pgoff_t page_offset;
+	int ret;
+
+	page_offset = ((unsigned long)vmf->virtual_address -
+			vma->vm_start) >> PAGE_SHIFT;
+	f_vaddr = (unsigned long)vmf->virtual_address;
+
+	mutex_lock(&dev->struct_mutex);
+
+	ret = rockchip_drm_gem_map_buf(obj, vma, f_vaddr, page_offset);
+	if (ret < 0)
+		DRM_ERROR("failed to map a buffer with user.\n");
+
+	mutex_unlock(&dev->struct_mutex);
+
+	return convert_to_vm_err_msg(ret);
+}
+
+int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct rockchip_drm_gem_obj *rockchip_gem_obj;
+	struct drm_gem_object *obj;
+	int ret;
+
+	/* set vm_area_struct. */
+	ret = drm_gem_mmap(filp, vma);
+	if (ret < 0) {
+		DRM_ERROR("failed to mmap.\n");
+		return ret;
+	}
+
+	obj = vma->vm_private_data;
+	rockchip_gem_obj = to_rockchip_gem_obj(obj);
+
+	ret = check_gem_flags(rockchip_gem_obj->flags);
+	if (ret < 0) {
+		drm_gem_vm_close(vma);
+		drm_gem_free_mmap_offset(obj);
+		return ret;
+	}
+
+	vma->vm_flags &= ~VM_PFNMAP;
+	vma->vm_flags |= VM_MIXEDMAP;
+
+	update_vm_cache_attr(rockchip_gem_obj, vma);
+
+	return ret;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.h b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
new file mode 100644
index 0000000..e322c42
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.h
@@ -0,0 +1,198 @@
+/* rockchip_drm_gem.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_gem.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_GEM_H_
+#define _ROCKCHIP_DRM_GEM_H_
+
+#define to_rockchip_gem_obj(x)	container_of(x,\
+			struct rockchip_drm_gem_obj, base)
+
+#define IS_NONCONTIG_BUFFER(f)		(f & ROCKCHIP_BO_NONCONTIG)
+
+/*
+ * rockchip drm gem buffer structure.
+ *
+ * @kvaddr: kernel virtual address to allocated memory region.
+ * *userptr: user space address.
+ * @dma_addr: bus address(accessed by dma) to allocated memory region.
+ *        - this address could be physical address without IOMMU and
+ *        device address with IOMMU.
+ * @write: whether pages will be written to by the caller.
+ * @pages: Array of backing pages.
+ * @sgt: sg table to transfer page data.
+ * @size: size of allocated memory region.
+ * @pfnmap: indicate whether memory region from userptr is mmaped with
+ * VM_PFNMAP or not.
+ */
+struct rockchip_drm_gem_buf {
+	void __iomem *kvaddr;
+	unsigned long userptr;
+	dma_addr_t dma_addr;
+	struct dma_attrs dma_attrs;
+	unsigned int write;
+	struct page **pages;
+	struct sg_table *sgt;
+	unsigned long size;
+	bool pfnmap;
+};
+
+/*
+ * rockchip drm buffer structure.
+ *
+ * @base: a gem object.
+ *      - a new handle to this gem object would be created
+ *      by drm_gem_handle_create().
+ * @buffer: a pointer to rockchip_drm_gem_buffer object.
+ *      - contain the information to memory region allocated
+ *      by user request or at framebuffer creation.
+ *      continuous memory region allocated by user request
+ *      or at framebuffer creation.
+ * @size: size requested from user, in bytes and this size is aligned
+ *      in page unit.
+ * @vma: a pointer to vm_area.
+ * @flags: indicate memory type to allocated buffer and cache attruibute.
+ *
+ * P.S. this object would be transferred to user as kms_bo.handle so
+ *      user can access the buffer through kms_bo.handle.
+ */
+struct rockchip_drm_gem_obj {
+	struct drm_gem_object base;
+	struct rockchip_drm_gem_buf *buffer;
+	unsigned long size;
+	struct vm_area_struct *vma;
+	unsigned int flags;
+};
+
+struct page **rockchip_gem_get_pages(struct drm_gem_object *obj, gfp_t gfpmask);
+
+/* destroy a buffer with gem object */
+void rockchip_drm_gem_destroy(struct rockchip_drm_gem_obj *rockchip_gem_obj);
+
+/* create a private gem object and initialize it. */
+struct rockchip_drm_gem_obj *rockchip_drm_gem_init(struct drm_device *dev,
+						      unsigned long size);
+
+/* create a new buffer with gem object */
+struct rockchip_drm_gem_obj *rockchip_drm_gem_create(struct drm_device *dev,
+						unsigned int flags,
+						unsigned long size);
+
+/*
+ * request gem object creation and buffer allocation as the size
+ * that it is calculated with framebuffer information such as width,
+ * height and bpp.
+ */
+int rockchip_drm_gem_create_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv);
+
+/*
+ * get dma address from gem handle and this function could be used for
+ * other drivers such as 2d/3d acceleration drivers.
+ * with this function call, gem object reference count would be increased.
+ */
+dma_addr_t *rockchip_drm_gem_get_dma_addr(struct drm_device *dev,
+					unsigned int gem_handle,
+					struct drm_file *filp);
+
+/*
+ * put dma address from gem handle and this function could be used for
+ * other drivers such as 2d/3d acceleration drivers.
+ * with this function call, gem object reference count would be decreased.
+ */
+void rockchip_drm_gem_put_dma_addr(struct drm_device *dev,
+					unsigned int gem_handle,
+					struct drm_file *filp);
+
+/* get buffer offset to map to user space. */
+int rockchip_drm_gem_map_offset_ioctl(struct drm_device *dev, void *data,
+				    struct drm_file *file_priv);
+
+/*
+ * mmap the physically continuous memory that a gem object contains
+ * to user space.
+ */
+int rockchip_drm_gem_mmap_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv);
+
+int rockchip_drm_gem_mmap_buffer(struct file *filp,
+				      struct vm_area_struct *vma);
+
+/* map user space allocated by malloc to pages. */
+int rockchip_drm_gem_userptr_ioctl(struct drm_device *dev, void *data,
+				      struct drm_file *file_priv);
+
+/* get buffer information to memory region allocated by gem. */
+int rockchip_drm_gem_get_ioctl(struct drm_device *dev, void *data,
+				      struct drm_file *file_priv);
+
+/* get buffer size to gem handle. */
+unsigned long rockchip_drm_gem_get_size(struct drm_device *dev,
+						unsigned int gem_handle,
+						struct drm_file *file_priv);
+
+/* free gem object. */
+void rockchip_drm_gem_free_object(struct drm_gem_object *gem_obj);
+
+/* create memory region for drm framebuffer. */
+int rockchip_drm_gem_dumb_create(struct drm_file *file_priv,
+			       struct drm_device *dev,
+			       struct drm_mode_create_dumb *args);
+
+/* map memory region for drm framebuffer to user space. */
+int rockchip_drm_gem_dumb_map_offset(struct drm_file *file_priv,
+				   struct drm_device *dev, uint32_t handle,
+				   uint64_t *offset);
+
+/* page fault handler and mmap fault address(virtual) to physical memory. */
+int rockchip_drm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+
+/* set vm_flags and we can change the vm attribute to other one at here. */
+int rockchip_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
+
+static inline int vma_is_io(struct vm_area_struct *vma)
+{
+	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
+}
+
+/* get a copy of a virtual memory region. */
+struct vm_area_struct *rockchip_gem_get_vma(struct vm_area_struct *vma);
+
+/* release a userspace virtual memory area. */
+void rockchip_gem_put_vma(struct vm_area_struct *vma);
+
+/* get pages from user space. */
+int rockchip_gem_get_pages_from_userptr(unsigned long start,
+						unsigned int npages,
+						struct page **pages,
+						struct vm_area_struct *vma);
+
+/* drop the reference to pages. */
+void rockchip_gem_put_pages_to_userptr(struct page **pages,
+					unsigned int npages,
+					struct vm_area_struct *vma);
+
+/* map sgt with dma region. */
+int rockchip_gem_map_sgt_with_dma(struct drm_device *drm_dev,
+				struct sg_table *sgt,
+				enum dma_data_direction dir);
+
+/* unmap sgt from dma region. */
+void rockchip_gem_unmap_sgt_from_dma(struct drm_device *drm_dev,
+				struct sg_table *sgt,
+				enum dma_data_direction dir);
+
+#endif
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_iommu.c b/drivers/gpu/drm/rockchip/rockchip_drm_iommu.c
new file mode 100644
index 0000000..ffc3170
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_iommu.c
@@ -0,0 +1,149 @@
+/* rockchip_drm_iommu.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_iommu.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drmP.h>
+#include <drm/rockchip_drm.h>
+
+#include <linux/dma-mapping.h>
+#include <linux/iommu.h>
+#include <linux/kref.h>
+
+#include <asm/dma-iommu.h>
+
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_iommu.h"
+
+/*
+ * drm_create_iommu_mapping - create a mapping structure
+ *
+ * @drm_dev: DRM device
+ */
+int drm_create_iommu_mapping(struct drm_device *drm_dev)
+{
+	struct dma_iommu_mapping *mapping = NULL;
+	struct rockchip_drm_private *priv = drm_dev->dev_private;
+	struct device *dev = drm_dev->dev;
+
+	if (!priv->da_start)
+		priv->da_start = ROCKCHIP_DEV_ADDR_START;
+	if (!priv->da_space_size)
+		priv->da_space_size = ROCKCHIP_DEV_ADDR_SIZE;
+
+	mapping = arm_iommu_create_mapping(&platform_bus_type, priv->da_start,
+						priv->da_space_size);
+
+	if (IS_ERR(mapping))
+		return PTR_ERR(mapping);
+
+	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
+					GFP_KERNEL);
+	if (!dev->dma_parms)
+		goto error;
+
+	dma_set_max_seg_size(dev, 0xffffffffu);
+	dev->archdata.mapping = mapping;
+
+	return 0;
+error:
+	arm_iommu_release_mapping(mapping);
+	return -ENOMEM;
+}
+
+/*
+ * drm_release_iommu_mapping - release iommu mapping structure
+ *
+ * @drm_dev: DRM device
+ *
+ * if mapping->kref becomes 0 then all things related to iommu mapping
+ * will be released
+ */
+void drm_release_iommu_mapping(struct drm_device *drm_dev)
+{
+	struct device *dev = drm_dev->dev;
+
+	arm_iommu_release_mapping(dev->archdata.mapping);
+}
+
+/*
+ * drm_iommu_attach_device- attach device to iommu mapping
+ *
+ * @drm_dev: DRM device
+ * @subdrv_dev: device to be attach
+ *
+ * This function should be called by sub drivers to attach it to iommu
+ * mapping.
+ */
+int drm_iommu_attach_device(struct drm_device *drm_dev,
+				struct device *subdrv_dev)
+{
+	struct device *dev = drm_dev->dev;
+	int ret;
+
+	if (!dev->archdata.mapping) {
+		DRM_ERROR("iommu_mapping is null.\n");
+		return -EFAULT;
+	}
+
+	subdrv_dev->dma_parms = devm_kzalloc(subdrv_dev,
+					sizeof(*subdrv_dev->dma_parms),
+					GFP_KERNEL);
+	if (!subdrv_dev->dma_parms)
+		return -ENOMEM;
+
+	dma_set_max_seg_size(subdrv_dev, 0xffffffffu);
+
+	ret = arm_iommu_attach_device(subdrv_dev, dev->archdata.mapping);
+	if (ret < 0) {
+		DRM_DEBUG_KMS("failed iommu attach.\n");
+		return ret;
+	}
+
+	/*
+	 * Set dma_ops to drm_device just one time.
+	 *
+	 * The dma mapping api needs device object and the api is used
+	 * to allocate physial memory and map it with iommu table.
+	 * If iommu attach succeeded, the sub driver would have dma_ops
+	 * for iommu and also all sub drivers have same dma_ops.
+	 */
+	if (!dev->archdata.dma_ops)
+		dev->archdata.dma_ops = subdrv_dev->archdata.dma_ops;
+
+	return 0;
+}
+
+/*
+ * drm_iommu_detach_device -detach device address space mapping from device
+ *
+ * @drm_dev: DRM device
+ * @subdrv_dev: device to be detached
+ *
+ * This function should be called by sub drivers to detach it from iommu
+ * mapping
+ */
+void drm_iommu_detach_device(struct drm_device *drm_dev,
+				struct device *subdrv_dev)
+{
+	struct device *dev = drm_dev->dev;
+	struct dma_iommu_mapping *mapping = dev->archdata.mapping;
+
+	if (!mapping || !mapping->domain)
+		return;
+
+	iommu_detach_device(mapping->domain, subdrv_dev);
+	drm_release_iommu_mapping(drm_dev);
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_iommu.h b/drivers/gpu/drm/rockchip/rockchip_drm_iommu.h
new file mode 100644
index 0000000..4fb4050
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_iommu.h
@@ -0,0 +1,76 @@
+/* rockchip_drm_iommu.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_iommu.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_IOMMU_H_
+#define _ROCKCHIP_DRM_IOMMU_H_
+
+#define ROCKCHIP_DEV_ADDR_START	0x20000000
+#define ROCKCHIP_DEV_ADDR_SIZE	0x40000000
+
+#ifdef CONFIG_DRM_ROCKCHIP_IOMMU
+
+int drm_create_iommu_mapping(struct drm_device *drm_dev);
+
+void drm_release_iommu_mapping(struct drm_device *drm_dev);
+
+int drm_iommu_attach_device(struct drm_device *drm_dev,
+				struct device *subdrv_dev);
+
+void drm_iommu_detach_device(struct drm_device *dev_dev,
+				struct device *subdrv_dev);
+
+static inline bool is_drm_iommu_supported(struct drm_device *drm_dev)
+{
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
+	struct device *dev = drm_dev->dev;
+
+	return dev->archdata.mapping ? true : false;
+#else
+	return false;
+#endif
+}
+
+#else
+
+struct dma_iommu_mapping;
+static inline int drm_create_iommu_mapping(struct drm_device *drm_dev)
+{
+	return 0;
+}
+
+static inline void drm_release_iommu_mapping(struct drm_device *drm_dev)
+{
+}
+
+static inline int drm_iommu_attach_device(struct drm_device *drm_dev,
+						struct device *subdrv_dev)
+{
+	return 0;
+}
+
+static inline void drm_iommu_detach_device(struct drm_device *drm_dev,
+						struct device *subdrv_dev)
+{
+}
+
+static inline bool is_drm_iommu_supported(struct drm_device *drm_dev)
+{
+	return false;
+}
+
+#endif
+#endif /* _ROCKCHIP_DRM_IOMMU_H_ */
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_plane.c b/drivers/gpu/drm/rockchip/rockchip_drm_plane.c
new file mode 100644
index 0000000..230a35b
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_plane.c
@@ -0,0 +1,290 @@
+/* rockchip_drm_plane.c
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_plane.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <drm/drmP.h>
+
+#include <drm/rockchip_drm.h>
+#include "rockchip_drm_drv.h"
+#include "rockchip_drm_crtc.h"
+#include "rockchip_drm_fb.h"
+#include "rockchip_drm_gem.h"
+#include "rockchip_drm_plane.h"
+
+#define to_rockchip_plane(x) container_of(x, struct rockchip_plane, base)
+
+struct rockchip_plane {
+	struct rockchip_drm_overlay overlay;
+	struct drm_plane base;
+	bool enabled;
+};
+
+static const uint32_t formats[] = {
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_NV12,
+	DRM_FORMAT_NV12MT,
+};
+
+/*
+ * This function is to get X or Y size shown via screen. This needs length and
+ * start position of CRTC.
+ *
+ *      <--- length --->
+ * CRTC ----------------
+ *      ^ start        ^ end
+ *
+ * There are six cases from a to f.
+ *
+ *             <----- SCREEN ----->
+ *             0                 last
+ *   ----------|------------------|----------
+ * CRTCs
+ * a -------
+ *        b -------
+ *        c --------------------------
+ *                 d --------
+ *                           e -------
+ *                                  f -------
+ */
+static int rockchip_plane_get_size(int start, unsigned length, unsigned last)
+{
+	int end = start + length;
+	int size = 0;
+
+	if (start <= 0) {
+		if (end > 0)
+			size = min_t(unsigned, end, last);
+	} else if (start <= last) {
+		size = min_t(unsigned, last - start, length);
+	}
+
+	return size;
+}
+
+int rockchip_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
+			  struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+			  unsigned int crtc_w, unsigned int crtc_h,
+			  uint32_t src_x, uint32_t src_y,
+			  uint32_t src_w, uint32_t src_h)
+{
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+	struct rockchip_drm_overlay *overlay = &rockchip_plane->overlay;
+	unsigned int actual_w;
+	unsigned int actual_h;
+	int nr;
+	int i;
+
+	nr = rockchip_drm_fb_get_buf_cnt(fb);
+	for (i = 0; i < nr; i++) {
+		struct rockchip_drm_gem_buf *buffer =
+					rockchip_drm_fb_buffer(fb, i);
+
+		if (!buffer) {
+			DRM_DEBUG_KMS("buffer is null\n");
+			return -EFAULT;
+		}
+
+		overlay->dma_addr[i] = buffer->dma_addr;
+
+		DRM_DEBUG_KMS("buffer: %d, dma_addr = 0x%lx\n",
+				i, (unsigned long)overlay->dma_addr[i]);
+	}
+
+	actual_w = rockchip_plane_get_size(crtc_x,
+					crtc_w, crtc->mode.hdisplay);
+	actual_h = rockchip_plane_get_size(crtc_y,
+					crtc_h, crtc->mode.vdisplay);
+
+	if (crtc_x < 0) {
+		if (actual_w)
+			src_x -= crtc_x;
+		crtc_x = 0;
+	}
+
+	if (crtc_y < 0) {
+		if (actual_h)
+			src_y -= crtc_y;
+		crtc_y = 0;
+	}
+
+	/* set drm framebuffer data. */
+	overlay->fb_x = src_x;
+	overlay->fb_y = src_y;
+	overlay->fb_width = fb->width;
+	overlay->fb_height = fb->height;
+	overlay->src_width = src_w;
+	overlay->src_height = src_h;
+	overlay->bpp = fb->bits_per_pixel;
+	overlay->pitch = fb->pitches[0];
+	overlay->pixel_format = fb->pixel_format;
+
+	/* set overlay range to be displayed. */
+	overlay->crtc_x = crtc_x;
+	overlay->crtc_y = crtc_y;
+	overlay->crtc_width = actual_w;
+	overlay->crtc_height = actual_h;
+
+	/* set drm mode data. */
+	overlay->mode_width = crtc->mode.hdisplay;
+	overlay->mode_height = crtc->mode.vdisplay;
+	overlay->refresh = crtc->mode.vrefresh;
+	overlay->scan_flag = crtc->mode.flags;
+
+	DRM_DEBUG_KMS("overlay : offset_x/y(%d,%d), width/height(%d,%d)",
+			overlay->crtc_x, overlay->crtc_y,
+			overlay->crtc_width, overlay->crtc_height);
+
+	rockchip_drm_crtc_plane_mode_set(crtc, overlay);
+
+	return 0;
+}
+
+void rockchip_plane_commit(struct drm_plane *plane)
+{
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+	struct rockchip_drm_overlay *overlay = &rockchip_plane->overlay;
+
+	rockchip_drm_crtc_plane_commit(plane->crtc, overlay->zpos);
+}
+
+void rockchip_plane_dpms(struct drm_plane *plane, int mode)
+{
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+	struct rockchip_drm_overlay *overlay = &rockchip_plane->overlay;
+
+	if (mode == DRM_MODE_DPMS_ON) {
+		if (rockchip_plane->enabled)
+			return;
+
+		rockchip_drm_crtc_plane_enable(plane->crtc, overlay->zpos);
+		rockchip_plane->enabled = true;
+	} else {
+		if (!rockchip_plane->enabled)
+			return;
+
+		rockchip_drm_crtc_plane_disable(plane->crtc, overlay->zpos);
+		rockchip_plane->enabled = false;
+	}
+}
+
+static int
+rockchip_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
+		     struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		     unsigned int crtc_w, unsigned int crtc_h,
+		     uint32_t src_x, uint32_t src_y,
+		     uint32_t src_w, uint32_t src_h)
+{
+	int ret;
+
+	ret = rockchip_plane_mode_set(plane, crtc, fb, crtc_x, crtc_y,
+			crtc_w, crtc_h, src_x >> 16, src_y >> 16,
+			src_w >> 16, src_h >> 16);
+	if (ret < 0)
+		return ret;
+
+	plane->crtc = crtc;
+
+	rockchip_plane_commit(plane);
+	rockchip_plane_dpms(plane, DRM_MODE_DPMS_ON);
+
+	return 0;
+}
+
+static int rockchip_disable_plane(struct drm_plane *plane)
+{
+	rockchip_plane_dpms(plane, DRM_MODE_DPMS_OFF);
+
+	return 0;
+}
+
+static void rockchip_plane_destroy(struct drm_plane *plane)
+{
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+
+	rockchip_disable_plane(plane);
+	drm_plane_cleanup(plane);
+	kfree(rockchip_plane);
+}
+
+static int rockchip_plane_set_property(struct drm_plane *plane,
+				     struct drm_property *property,
+				     uint64_t val)
+{
+	struct drm_device *dev = plane->dev;
+	struct rockchip_plane *rockchip_plane = to_rockchip_plane(plane);
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+
+	if (property == dev_priv->plane_zpos_property) {
+		rockchip_plane->overlay.zpos = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct drm_plane_funcs rockchip_plane_funcs = {
+	.update_plane = rockchip_update_plane,
+	.disable_plane = rockchip_disable_plane,
+	.destroy = rockchip_plane_destroy,
+	.set_property = rockchip_plane_set_property,
+};
+
+static void rockchip_plane_attach_zpos_property(struct drm_plane *plane)
+{
+	struct drm_device *dev = plane->dev;
+	struct rockchip_drm_private *dev_priv = dev->dev_private;
+	struct drm_property *prop;
+
+	prop = dev_priv->plane_zpos_property;
+	if (!prop) {
+		prop = drm_property_create_range(dev, 0, "zpos", 0,
+						 MAX_PLANE - 1);
+		if (!prop)
+			return;
+
+		dev_priv->plane_zpos_property = prop;
+	}
+
+	drm_object_attach_property(&plane->base, prop, 0);
+}
+
+struct drm_plane *rockchip_plane_init(struct drm_device *dev,
+				    unsigned long possible_crtcs, bool priv)
+{
+	struct rockchip_plane *rockchip_plane;
+	int err;
+
+	rockchip_plane = kzalloc(sizeof(struct rockchip_plane), GFP_KERNEL);
+	if (!rockchip_plane)
+		return NULL;
+
+	err = drm_plane_init(dev, &rockchip_plane->base, possible_crtcs,
+			      &rockchip_plane_funcs, formats,
+			      ARRAY_SIZE(formats), priv);
+	if (err) {
+		DRM_ERROR("failed to initialize plane\n");
+		kfree(rockchip_plane);
+		return NULL;
+	}
+
+	if (priv)
+		rockchip_plane->overlay.zpos = DEFAULT_ZPOS;
+	else
+		rockchip_plane_attach_zpos_property(&rockchip_plane->base);
+
+	return &rockchip_plane->base;
+}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_plane.h b/drivers/gpu/drm/rockchip/rockchip_drm_plane.h
new file mode 100644
index 0000000..3832496
--- /dev/null
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_plane.h
@@ -0,0 +1,30 @@
+/* rockchip_drm_plane.h
+ *
+ * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
+ * Author:mark yao <mark.yao@rock-chips.com>
+ *
+ * based on exynos_drm_plane.h
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _ROCKCHIP_DRM_PLANE_H_
+#define _ROCKCHIP_DRM_PLANE_H_
+
+int rockchip_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
+			  struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+			  unsigned int crtc_w, unsigned int crtc_h,
+			  uint32_t src_x, uint32_t src_y,
+			  uint32_t src_w, uint32_t src_h);
+void rockchip_plane_commit(struct drm_plane *plane);
+void rockchip_plane_dpms(struct drm_plane *plane, int mode);
+struct drm_plane *rockchip_plane_init(struct drm_device *dev,
+				    unsigned long possible_crtcs, bool priv);
+#endif /* _ROCKCHIP_DRM_PLANE_H_ */
diff --git a/include/uapi/drm/rockchip_drm.h b/include/uapi/drm/rockchip_drm.h
new file mode 100644
index 0000000..7f705f4
--- /dev/null
+++ b/include/uapi/drm/rockchip_drm.h
@@ -0,0 +1,155 @@
+/* rockchip_drm.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *       mark yao<yzq@rock-chips.com>
+ *
+ * base on exynos_drm.h
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef _UAPI_ROCKCHIP_DRM_H_
+#define _UAPI_ROCKCHIP_DRM_H_
+
+#include <drm/drm.h>
+
+/**
+ * User-desired buffer creation information structure.
+ *
+ * @size: user-desired memory allocation size.
+ *     - this size value would be page-aligned internally.
+ * @flags: user request for setting memory type or cache attributes.
+ * @handle: returned a handle to created gem object.
+ *     - this handle will be set by gem module of kernel side.
+ */
+struct drm_rockchip_gem_create {
+	uint64_t size;
+	unsigned int flags;
+	unsigned int handle;
+};
+
+/**
+ * A structure for getting buffer offset.
+ *
+ * @handle: a pointer to gem object created.
+ * @pad: just padding to be 64-bit aligned.
+ * @offset: relatived offset value of the memory region allocated.
+ *     - this value should be set by user.
+ */
+struct drm_rockchip_gem_map_off {
+	unsigned int handle;
+	unsigned int pad;
+	uint64_t offset;
+};
+
+/**
+ * A structure for mapping buffer.
+ *
+ * @handle: a handle to gem object created.
+ * @pad: just padding to be 64-bit aligned.
+ * @size: memory size to be mapped.
+ * @mapped: having user virtual address mmaped.
+ *      - this variable would be filled by rockchip gem module
+ *      of kernel side with user virtual address which is allocated
+ *      by do_mmap().
+ */
+struct drm_rockchip_gem_mmap {
+	unsigned int handle;
+	unsigned int pad;
+	uint64_t size;
+	uint64_t mapped;
+};
+
+/**
+ * A structure to gem information.
+ *
+ * @handle: a handle to gem object created.
+ * @flags: flag value including memory type and cache attribute and
+ *      this value would be set by driver.
+ * @size: size to memory region allocated by gem and this size would
+ *      be set by driver.
+ */
+struct drm_rockchip_gem_info {
+	unsigned int handle;
+	unsigned int flags;
+	uint64_t size;
+};
+
+/* memory type definitions. */
+enum e_drm_rockchip_gem_mem_type {
+	/* Physically Continuous memory and used as default. */
+	ROCKCHIP_BO_CONTIG = 0 << 0,
+	/* Physically Non-Continuous memory. */
+	ROCKCHIP_BO_NONCONTIG = 1 << 0,
+	/* non-cachable mapping and used as default. */
+	ROCKCHIP_BO_NONCACHABLE = 0 << 1,
+	/* cachable mapping. */
+	ROCKCHIP_BO_CACHABLE = 1 << 1,
+	/* write-combine mapping. */
+	ROCKCHIP_BO_WC = 1 << 2,
+	ROCKCHIP_BO_MASK = ROCKCHIP_BO_NONCONTIG | ROCKCHIP_BO_CACHABLE |
+					ROCKCHIP_BO_WC
+};
+
+enum drm_rockchip_ops_id {
+	ROCKCHIP_DRM_OPS_SRC,
+	ROCKCHIP_DRM_OPS_DST,
+	ROCKCHIP_DRM_OPS_MAX,
+};
+
+struct drm_rockchip_sz {
+	__u32 hsize;
+	__u32 vsize;
+};
+
+struct drm_rockchip_pos {
+	__u32 x;
+	__u32 y;
+	__u32 w;
+	__u32 h;
+};
+
+enum drm_rockchip_flip {
+	ROCKCHIP_DRM_FLIP_NONE = (0 << 0),
+	ROCKCHIP_DRM_FLIP_VERTICAL = (1 << 0),
+	ROCKCHIP_DRM_FLIP_HORIZONTAL = (1 << 1),
+	ROCKCHIP_DRM_FLIP_BOTH = ROCKCHIP_DRM_FLIP_VERTICAL |
+			ROCKCHIP_DRM_FLIP_HORIZONTAL,
+};
+
+enum drm_rockchip_degree {
+	ROCKCHIP_DRM_DEGREE_0,
+	ROCKCHIP_DRM_DEGREE_90,
+	ROCKCHIP_DRM_DEGREE_180,
+	ROCKCHIP_DRM_DEGREE_270,
+};
+
+enum drm_rockchip_planer {
+	ROCKCHIP_DRM_PLANAR_Y,
+	ROCKCHIP_DRM_PLANAR_CB,
+	ROCKCHIP_DRM_PLANAR_CR,
+	ROCKCHIP_DRM_PLANAR_MAX,
+};
+
+#define DRM_ROCKCHIP_GEM_CREATE		0x00
+#define DRM_ROCKCHIP_GEM_MAP_OFFSET	0x01
+#define DRM_ROCKCHIP_GEM_MMAP		0x02
+/* Reserved 0x03 ~ 0x05 for rockchip specific gem ioctl */
+#define DRM_ROCKCHIP_GEM_GET		0x04
+
+#define DRM_IOCTL_ROCKCHIP_GEM_CREATE		DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_CREATE, struct drm_rockchip_gem_create)
+
+#define DRM_IOCTL_ROCKCHIP_GEM_MAP_OFFSET	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_MAP_OFFSET, struct drm_rockchip_gem_map_off)
+
+#define DRM_IOCTL_ROCKCHIP_GEM_MMAP	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_MMAP, struct drm_rockchip_gem_mmap)
+
+#define DRM_IOCTL_ROCKCHIP_GEM_GET	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_ROCKCHIP_GEM_GET,	struct drm_rockchip_gem_info)
+#endif /* _UAPI_ROCKCHIP_DRM_H_ */
-- 
1.7.9.5



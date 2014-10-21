Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaJUAnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:43:22 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:52524 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaJUAnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:43:20 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <9af849e15fa4dc58ef7c291329c1549b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5445AC1D.8010007@rock-chips.com>
Date: Tue, 21 Oct 2014 08:43:09 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org,
        olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com,
        kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, Mark Yao <mark.yao@rock-chips.com>
Subject: [GIT PULL] core drm support for Rockchip SoCs
References: <1412763781-31533-1-git-send-email-mark.yao@rock-chips.com>
In-Reply-To: <1412763781-31533-1-git-send-email-mark.yao@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave

The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9:

    Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:

    https://github.com/markyzq/kernel-drm-rockchip.git  drmrockchip

for you to fetch changes up to 45bb5f4e7e82b30e9e7069c73441413680c9a59f:

    dt-bindings: video: Add documentation for rockchip vop (2014-10-17
16:39:31 +0800)

----------------------------------------------------------------
Mark yao (3):
        drm: rockchip: Add basic drm driver
        dt-bindings: video: Add for rockchip display subsytem
        dt-bindings: video: Add documentation for rockchip vop

   .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
   .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
   drivers/gpu/drm/Kconfig                            |    2 +
   drivers/gpu/drm/Makefile                           |    1 +
   drivers/gpu/drm/rockchip/Kconfig                   |   17 +
   drivers/gpu/drm/rockchip/Makefile                  |    8 +
   drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  449 ++++++
   drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   54 +
   drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  200 +++
   drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +++
   drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   20 +
   drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  293 ++++
   drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
   drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1427 ++++++++++++++++++++
   drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  196 +++
   16 files changed, 3036 insertions(+)
   create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt
   create mode 100644 Documentation/devicetree/bindings/video/rockchip-vop.txt
   create mode 100644 drivers/gpu/drm/rockchip/Kconfig
   create mode 100644 drivers/gpu/drm/rockchip/Makefile
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.c
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_drv.h
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.c
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fb.h
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.c
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_gem.h
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.c
   create mode 100644 drivers/gpu/drm/rockchip/rockchip_drm_vop.h



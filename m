Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaK0HCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:02:01 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:38729 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaK0HB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:01:58 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <9de5d695e2f30b510dff84f2553a15c1>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5476CC59.6080607@rock-chips.com>
Date: Thu, 27 Nov 2014 15:01:45 +0800
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
        olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, xw@rock-chips.com,
        Mark Yao <mark.yao@rock-chips.com>
Subject: [GIT PULL] core drm support for Rockchip SoCs v14
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
In-Reply-To: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave

     this pull request is for rockchip drm v14, based on Joerg's iommu 
arm/rockchip branch.

The following changes since commit 656d7077d8ffd1c2492d4a0a354367ab2e545059:

   dt-bindings: iommu: Add documentation for rockchip iommu (2014-11-03 
17:29:09 +0100)

are available in the git repository at:

   https://github.com/markyzq/kernel-drm-rockchip.git drm_iommu

for you to fetch changes up to aab18af3a93353bc43897b716fd7e12d5998b9bc:

   dt-bindings: video: Add documentation for rockchip vop (2014-11-27 
13:38:17 +0800)

----------------------------------------------------------------
Mark Yao (3):
       drm: rockchip: Add basic drm driver
       dt-bindings: video: Add for rockchip display subsytem
       dt-bindings: video: Add documentation for rockchip vop

  .../devicetree/bindings/video/rockchip-drm.txt     |   19 +
  .../devicetree/bindings/video/rockchip-vop.txt     |   58 +
  drivers/gpu/drm/Kconfig                            |    2 +
  drivers/gpu/drm/Makefile                           |    1 +
  drivers/gpu/drm/rockchip/Kconfig                   |   17 +
  drivers/gpu/drm/rockchip/Makefile                  |    8 +
  drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |  483 +++++++
  drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   55 +
  drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |  200 +++
  drivers/gpu/drm/rockchip/rockchip_drm_fb.h         |   28 +
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c      |  210 +++
  drivers/gpu/drm/rockchip/rockchip_drm_fbdev.h      |   21 +
  drivers/gpu/drm/rockchip/rockchip_drm_gem.c        |  294 ++++
  drivers/gpu/drm/rockchip/rockchip_drm_gem.h        |   54 +
  drivers/gpu/drm/rockchip/rockchip_drm_vop.c        | 1459 
++++++++++++++++++++
  drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  201 +++
  16 files changed, 3110 insertions(+)
  create mode 100644 
Documentation/devicetree/bindings/video/rockchip-drm.txt
  create mode 100644 
Documentation/devicetree/bindings/video/rockchip-vop.txt
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



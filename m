Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaGCLUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:20:14 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:34771 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaGCLUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:20:12 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <5b03da041003ee722aa8d942ff58a5ff>
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
Subject: [PATCH] add Drm driver for Rockchip
Date: Thu,  3 Jul 2014 19:08:12 +0800
Message-Id: <1404385693-27388-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mark <mark.yao@rock-chips.com>

This patch is a DRM Driver for Rockchip Socs and now only add the
framework of Rockchips Socs, but we will add Rockchips Socs soon.

mark (1):
  drm: Add Drm driver for Rockchip Socs


-- 
1.7.9.5



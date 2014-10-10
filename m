Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaJJWZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:25:30 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63690 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaJJWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:25:28 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Fix up rk3288 smp cpu hotplug
Date: Fri, 10 Oct 2014 15:25:13 -0700
Message-Id: <1412979915-19746-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the CA12/CA17 MPCore multiprocessor, the active processors might be
stalled when the individual processor is powered down.
For rk3288, we can avoid this prolbem by softreset the processor before
power it down.


Kever Yang (2):
  ARM: rockchip: fix up rk3288 smp cpu hotplug
  ARM: dts: rockchip: add reset for CPU nodes

 arch/arm/boot/dts/rk3288.dtsi    |  4 ++++
 arch/arm/mach-rockchip/platsmp.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaIPKrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:47:13 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41936 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaIPKrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:47:10 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] Documentation: dt-bindings: add dt binding info for rk3288-smp
Date: Tue, 16 Sep 2014 18:44:28 +0800
Message-Id: <1410864271-9277-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com>
References: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add documentation for rk3288 smp dt binding

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v2:
- add documentation

 Documentation/devicetree/bindings/arm/cpus.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 298e2f6..4b46233 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -195,6 +195,7 @@ nodes to be present and contain the properties described below.
 			    "qcom,kpss-acc-v1"
 			    "qcom,kpss-acc-v2"
 			    "rockchip,rk3066-smp"
+			    "rockchip,rk3288-smp"
 
 	- cpu-release-addr
 		Usage: required for systems that have an "enable-method"
-- 
1.9.1


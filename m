Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab3GENwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:52:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18113 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830Ab3GENwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:52:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 05 Jul 2013 06:53:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <cw00.choi@samsung.com>, <myungjoo.ham@samsung.com>,
        <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <gg@slimlogic.co.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] extcon: palmas: rename device tree binding matching with file name
Date: Fri, 5 Jul 2013 19:29:51 +0530
Message-ID: <1373032792-29001-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver name is extcon/extcon-palmas.c and hence renaming the
device tree binding document to extcon-palmas.txt.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../extcon/{extcon-twl.txt => extcon-palmas.txt}   |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/extcon/{extcon-twl.txt => extcon-palmas.txt} (100%)

diff --git a/Documentation/devicetree/bindings/extcon/extcon-twl.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
similarity index 100%
rename from Documentation/devicetree/bindings/extcon/extcon-twl.txt
rename to Documentation/devicetree/bindings/extcon/extcon-palmas.txt
-- 
1.7.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbbAEKHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:07:32 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8676 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbAEKH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:07:29 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <p.zabel@pengutronix.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kaixu.xia@linaro.org>, <xiakaixu@huawei.com>
Subject: [PATCH] Documentation: of: fix typo in graph bindings
Date: Mon, 5 Jan 2015 18:02:16 +0800
Message-ID: <1420452136-76466-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just fix a minor typo about the example path.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 Documentation/devicetree/bindings/graph.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/graph.txt b/Documentation/devicetree/bindings/graph.txt
index 1a69c07..fcb1c6a 100644
--- a/Documentation/devicetree/bindings/graph.txt
+++ b/Documentation/devicetree/bindings/graph.txt
@@ -19,7 +19,7 @@ type of the connections, they just map their existence. Specific properties
 may be described by specialized bindings depending on the type of connection.
 
 To see how this binding applies to video pipelines, for example, see
-Documentation/device-tree/bindings/media/video-interfaces.txt.
+Documentation/devicetree/bindings/media/video-interfaces.txt.
 Here the ports describe data interfaces, and the links between them are
 the connecting data buses. A single port with multiple connections can
 correspond to multiple devices being connected to the same physical bus.
-- 
1.8.5.5


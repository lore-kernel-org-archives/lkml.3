Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3ITLNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:13:34 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:53559 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3ITLNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:13:33 -0400
From: Oliver Schinagl <oliver+list@schinagl.nl>
To: rob@landley.net
Cc: linux-kernel@vger.kernel.org, maxime-ripard@free-electrons.com,
        linux-sunxi@google-groups.com, devicetree@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, oliver@schinagl.nl
Subject: [PATCH] ARM: sunxi: doc: Add sun7i (A20) interrupt table
Date: Fri, 20 Sep 2013 13:12:39 +0200
Message-Id: <1379675560-30656-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

Having the interrupt tables documented in the kernel documentation is useful as
a quick reference.

Oliver Schinagl (1):
  ARM: sunxi: doc: Add sun7i (A20) interrupt table

 .../interrupt-controller/sunxi/sun7i-a20.txt       | 102 +++++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/sunxi/sun7i-a20.txt

-- 
1.8.1.5


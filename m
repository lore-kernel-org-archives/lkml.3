Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3DBWq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:46:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761207Ab3DBWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Hutter <hutter.eric@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 083/124] ARM: kirkwood: Fix chip-delay for GoFlex Net
Date: Tue,  2 Apr 2013 15:11:05 -0700
Message-Id: <20130402221113.735676862@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Hutter <hutter.eric@gmail.com>

commit 2992714d431976c4b154875bd18ba61bf4df3b93 upstream.

This fixes "Too few good blocks within range" issues on GoFlex Net by setting
chip-delay to 40.

The basic problem was discussed at http://forum.doozan.com/read.php?2,7451

Signed-off-by: Eric Hutter <hutter.eric@gmail.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/kirkwood-goflexnet.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/kirkwood-goflexnet.dts
+++ b/arch/arm/boot/dts/kirkwood-goflexnet.dts
@@ -77,6 +77,7 @@
 		};
 
 		nand@3000000 {
+			chip-delay = <40>;
 			status = "okay";
 
 			partition@0 {



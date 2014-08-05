Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaHESga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:36:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbaHESOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.14 03/39] ARM: dts: fix L2 address in Hi3620
Date: Tue,  5 Aug 2014 11:13:40 -0700
Message-Id: <20140805181336.131286696@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojian Zhuang <haojian.zhuang@linaro.org>

commit 28c9770bcbd2b6dbab99669825a2f8fa69e6d35b upstream.

Fix the address of L2 controler register in hi3620 SoC.
This has been wrong from the point that the file was merged
in v3.14.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Acked-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/hi3620.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/hi3620.dtsi
+++ b/arch/arm/boot/dts/hi3620.dtsi
@@ -73,7 +73,7 @@
 
 		L2: l2-cache {
 			compatible = "arm,pl310-cache";
-			reg = <0xfc10000 0x100000>;
+			reg = <0x100000 0x100000>;
 			interrupts = <0 15 4>;
 			cache-unified;
 			cache-level = <2>;



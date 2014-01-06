Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbaAFWmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbaAFWmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Vinson Lee <vlee@twopensource.com>
Subject: [PATCH 3.4 13/43] intel_idle: enable IVB Xeon support
Date: Mon,  6 Jan 2014 14:39:30 -0800
Message-Id: <20140106223942.634080566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

commit 23795e580cad5d6b73d47d51b9074ce3e58bf334 upstream.

IVB Xeon currently shares the same parameters IVB client.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/idle/intel_idle.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -399,6 +399,7 @@ static const struct x86_cpu_id intel_idl
 	ICPU(0x2a, idle_cpu_snb),
 	ICPU(0x2d, idle_cpu_snb),
 	ICPU(0x3a, idle_cpu_ivb),
+	ICPU(0x3e, idle_cpu_ivb),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);



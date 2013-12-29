Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3L2V5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:57:35 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31758 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267Ab3L2Vvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832520"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-input@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
        linux-pcmcia@lists.infradead.org, rtc-linux@googlegroups.com,
        linuxppc-dev@lists.ozlabs.org, platform-driver-x86@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: [PATCH 0/25] fix error return code
Date: Sun, 29 Dec 2013 23:47:15 +0100
Message-Id: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where the return variable is not set to an error
code in an error case.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3HSLVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:21:09 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:1124 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343Ab3HSLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:21:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24233026"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-fbdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH 0/7] replace devm_request_and_ioremap by devm_ioremap_resource
Date: Mon, 19 Aug 2013 13:20:34 +0200
Message-Id: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_request_and_ioremap has been replaced by devm_ioremap_resource, which
gives more informative error return code information.  This patch series
removes the remaining uses of devm_request_and_ioremap.

This patch series was generated using the semantic patch
scripts/coccinelle/api/devm_ioremap_resource.cocci from the Linux kernel
source tree.  Manual modifications have been made to move associated calls
to platform_get_resource closer to the resulting call to
devm_ioremap_resource and to remove the associated error handling code.


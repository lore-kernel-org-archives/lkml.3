Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaHTQks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:40:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaHTQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:40:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add MODULE_ALIAS for Xen pciback. (v1)
Date: Wed, 20 Aug 2014 12:40:37 -0400
Message-Id: <1408552838-4032-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers had this in them except the Xen pciback.
This patch fixes that.

 drivers/xen/xen-pciback/pci_stub.c | 1 +
 1 file changed, 1 insertion(+)

Konrad Rzeszutek Wilk (1):
      xen-pciback: Add MODULE_ALIAS for pciback.


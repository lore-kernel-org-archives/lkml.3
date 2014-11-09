Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaKIJLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:11:47 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:60325 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbaKIJLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:11:41 -0500
X-IronPort-AV: E=Sophos;i="5.07,345,1413237600"; 
   d="scan'208";a="105805273"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        HPDD-discuss@ml01.01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 0/3] remove final uses of the GOTO macro
Date: Sun,  9 Nov 2014 10:06:31 +0100
Message-Id: <1415523994-12520-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove final uses of the GOTO macro, and remove the associated macro and
underlying function.

 drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h |   12 
 drivers/staging/lustre/lustre/libcfs/debug.c               |    8 
 drivers/staging/lustre/lustre/osc/osc_cache.c              |  168 ++++++++-----
 3 files changed, 110 insertions(+), 78 deletions(-)

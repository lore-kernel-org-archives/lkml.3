Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbaCZVfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:35:11 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:16391 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbaCZVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:35:07 -0400
X-IronPort-AV: E=Sophos;i="4.97,737,1389740400"; 
   d="scan'208";a="64902681"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-serial@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-mips@linux-mips.org,
        linux-hams@vger.kernel.org
Subject: [PATCH 0/7] replace del_timer by del_timer_sync
Date: Wed, 26 Mar 2014 22:33:38 +0100
Message-Id: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches replace del_timer by del_timer_sync in module_exit functions.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaDANuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:50:12 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7117 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbaDANuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:50:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,772,1389740400"; 
   d="scan'208";a="65838559"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [PATCH 0/3] replace del_timer by del_timer_sync
Date: Tue,  1 Apr 2014 15:49:16 +0200
Message-Id: <1396360159-16244-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches replace del_timer by del_timer_sync in remove functions.


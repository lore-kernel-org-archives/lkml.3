Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670Ab3E1PyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:54:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:29915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934567Ab3E1Px6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,758,1363158000"; 
   d="scan'208";a="309012397"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Cris <linux-cris-kernel@axis.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] arch/cris: old patch to use hex2bin
Date: Tue, 28 May 2013 18:53:51 +0300
Message-Id: <1369756432-5552-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
References: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert, would you like to add following patch to your tree as well?

Andy Shevchenko (1):
  cris: kgdb: use native hex2bin

 arch/cris/arch-v10/kernel/kgdb.c | 50 ++++++----------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

-- 
1.8.2.rc0.22.gb3600c3


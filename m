Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015AbaGDMwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:52:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15412 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaGDMwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:52:39 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-a8-53b6a3951ed9
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/3] extcon: max77693: fixes
Date: Fri, 04 Jul 2014 15:51:23 +0300
Message-id: <cover.1404478227.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJMWRmVeSWpSXmKPExsVy+t/xy7pTF28LNnh4Ttji+pfnrBa3/u5l
	tri8aw6bA7NH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZbz+OYul4B9zRfeKP6wNjBOZuxg5
	OSQETCSeXGqCssUkLtxbz9bFyMUhJLCUUWLJ+ttMEE4nk8TDnb3sIFVsAnoSG5p/ANkcHCIC
	khIt+8xAwswCXhIn/34DCwsL6Egs2ZYNEmYRUJX4v3AjWCevgKXEzmU72CB2yUmcPDaZdQIj
	9wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYId79uoNx6TGrQ4wCHIxKPLwNLduChVgT
	y4orcw8xSnAwK4nwas0BCvGmJFZWpRblxxeV5qQWH2Jk4uCUamD0bBM7OVnuh1HuCvG3dxt2
	b2Wf/ufF5cSCE48y5RovHbmRUjs/YIHFW/7662b5ws93T+qSqby/g0dXW0ayJ5hr4WeJTP+2
	Ih4nDV6bUNbu2brVKVdL31WyWj5+vfTr9brYo3F8Px5/9zq/0/DsPZ1fRxwn1L11lP7d5bGc
	zyC8cc7aDcEcG24psRRnJBpqMRcVJwIAbMFQ7swBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found out that this commits are missing from upstream kernel.
Please take care to apply.

Thanks,
Dmitry

Dmitry Kasatkin (2):
  extcon: max77693: Differentiate info message for easier debugging
  extcon: max77693: Force using UART path for jig

Jonghwa Lee (1):
  extcon: max77693: Fix bug related to MAX77693 irq when set ADC
    debounce time

 drivers/extcon/extcon-max77693.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

-- 
1.9.1


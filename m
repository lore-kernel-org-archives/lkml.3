Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaLCINd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:13:33 -0500
Received: from out21.biz.mail.alibaba.com ([205.204.114.132]:50735 "EHLO
	out21.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbaLCINa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:13:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g06003;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=3;RT=3;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Con Kolivas'" <kernel@kolivas.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Hillf Danton" <hillf.zj@alibaba-inc.com>
Subject: Re: [ANNOUNCE] BFS CPU scheduler v0.450 with SMT nice support for linux-3.16
Date: Wed, 03 Dec 2014 16:12:45 +0800
Message-ID: <026301d00ed0$eb723020$c2569060$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAOz963bt2VnMs0SiWPPn7iFMDIqQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Con
> 
> This is to announce a resync and  update of the Brain Fuck Scheduler,
> version 0.450 for the latest stable linux kernel.
> 
[...]
> The patch against linux-3.16(.x) is available here:
> http://ck.kolivas.org/patches/bfs/3.0/3.16/3.16-sched-bfs-450.patch
> 
$ grep -nr above_background_load  bfs/src
bfs/src/3.16-sched-bfs-450.patch:689:+bool above_background_load(void);
bfs/src/3.16-sched-bfs-450.patch:736:+static inline bool above_background_load(void)
bfs/src/3.16-sched-bfs-450.patch:1665:+bool above_background_load(void)

Would you please pin-point what is that routine used for?

Thanks
Hillf


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3INEMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:12:36 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57385 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3INEMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:12:35 -0400
Message-ID: <5233E216.3030506@huawei.com>
Date: Sat, 14 Sep 2013 12:12:06 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] edac: remove .c suffix from the mod name
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some edac drivers used 'xxx_edac.c' as mod name,
but others used 'xxx_edac'. So remove .c suffix.

Xie XiuQi (5):
  i5000_edac: remove .c suffix from the mod name
  i5100_edac: remove .c suffix from the mod name
  i5400_edac: remove .c suffix from the mod name
  i7300_edac: remove .c suffix from the mod name
  i7core_edac: remove .c suffix from the mod name

 drivers/edac/i5000_edac.c  | 2 +-
 drivers/edac/i5100_edac.c  | 4 +++-
 drivers/edac/i5400_edac.c  | 2 +-
 drivers/edac/i7300_edac.c  | 2 +-
 drivers/edac/i7core_edac.c | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.8.2.2



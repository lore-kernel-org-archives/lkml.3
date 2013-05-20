Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3ETCas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:30:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37149 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3ETCaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:30:46 -0400
Message-ID: <51998AA9.6070206@huawei.com>
Date: Mon, 20 May 2013 10:30:01 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <jlee@suse.com>, <matthew.garrett@nebula.com>, <corentin.chary@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
        <acpi4asus-user@lists.sourceforge.net>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 0/3]  fix x86 driver memleak
References: <1368889004-5520-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1368889004-5520-1-git-send-email-libo.chen@huawei.com>
X-Forwarded-Message-Id: <1368889004-5520-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix memleak or invalite point acesss about x86 platform drivers

Libo Chen (3):
  x86: msi-laptop: fix memleak
  x86: asus-laptop: fix invalid point access
  x86 platform drivers: fix gpio leak

 drivers/platform/x86/asus-laptop.c     |  1 -
 drivers/platform/x86/intel_pmic_gpio.c |  5 ++++-
 drivers/platform/x86/msi-laptop.c      | 24 ++++++++++--------------
 3 files changed, 14 insertions(+), 16 deletions(-)
-- 
1.8.1.2







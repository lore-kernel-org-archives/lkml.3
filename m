Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934567AbaDJFZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 01:25:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:46580 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaDJFZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 01:25:50 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Tejun Heo <tj@kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        Kefeng Wang <kefeng.wang@linaro.org>
Subject: [PATCH V2 0/2] ahci: support for hisilicon sata
Date: Thu, 10 Apr 2014 13:24:26 +0800
Message-ID: <1397107468-640-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kefeng Wang <kefeng.wang@linaro.org>

changes in v2:

make code more concise according to Hans's advice.

Kefeng Wang (2):
  ata: ahci: append new hflag AHCI_HFLAG_NO_FBS
  ahci: add support for Hisilicon sata

 .../devicetree/bindings/ata/ahci-platform.txt      |    3 ++-
 drivers/ata/ahci.h                                 |    1 +
 drivers/ata/ahci_platform.c                        |    6 +++++-
 drivers/ata/libahci.c                              |    5 +++++
 4 files changed, 13 insertions(+), 2 deletions(-)



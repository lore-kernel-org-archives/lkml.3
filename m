Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaDUEBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:01:55 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37951 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaDUEBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:01:53 -0400
From: Kefeng Wang <kefeng.wang@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com
Subject: [PATCH v3 0/2] ahci: add support for hisilicon sata
Date: Mon, 21 Apr 2014 12:01:40 +0800
Message-Id: <1398052903-10322-1-git-send-email-kefeng.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes in v3:

1) move NO_FBS chunk after YES_FBS, Tejun's suggestion
2) use ata_port_info pointer to avoid struct ata_port_info
   on the stack twice

changes in v2:

1) make code more concise according to Hans's advice

Kefeng Wang (2):
  ata: ahci: append new hflag AHCI_HFLAG_NO_FBS
  ahci: add support for Hisilicon sata

 .../devicetree/bindings/ata/ahci-platform.txt      |    3 ++-
 drivers/ata/ahci.h                                 |    1 +
 drivers/ata/ahci_platform.c                        |   10 ++++++++--
 drivers/ata/libahci.c                              |    5 +++++
 4 files changed, 16 insertions(+), 3 deletions(-)

-- 
1.7.9.5


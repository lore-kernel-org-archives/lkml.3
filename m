Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaB1Q0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:26:04 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:52128 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbaB1Q0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:26:01 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] checkpatch: fixes for vendor compatible check
Date: Fri, 28 Feb 2014 17:25:40 +0100
Message-Id: <1393604742-14317-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since v1 [1]:
- Add check for vendors with '-', as suggested by Joe Perches

Regards,
Florian

[1] http://thread.gmane.org/gmane.linux.drivers.devicetree/63770


Florian Vaussard (2):
  checkpatch: check vendor compatible with dashes
  checkpatch: fix spurious vendor compatible warnings

 scripts/checkpatch.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.5.3


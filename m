Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3CYHEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:04:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59973 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab3CYHEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:04:35 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <nsekhar@ti.com>, <jacmet@sunsite.dk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <prakash.pm@ti.com>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 0/2] Update device tree binding document for pwm-tiehrpwm & pwm-tiecap
Date: Mon, 25 Mar 2013 12:34:51 +0530
Message-ID: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update device tree document of pwm-tiehrpwm & pwm-tiecap in order to reflect the
usage of similar modules in both da850 and am33xx platforms.

Philip Avinash (2):
  pwm: pwm-tiecap: Update device-tree binding document
  pwm: pwm-tiehrpwm: Update device-tree binding document

 .../devicetree/bindings/pwm/pwm-tiecap.txt         |   12 ++++++++++--
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

-- 
1.7.9.5


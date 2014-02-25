Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaBYGWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:22:43 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19908 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaBYGWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:22:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Feb 2014 22:19:01 -0800
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH 0/2] expose lm90 to thermal fw
Date: Tue, 25 Feb 2014 14:21:39 +0800
Message-ID: <1393309301-28337-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose lm90 to thermal framework via DT nodes.

The [PATCH 1/2] had reviewed in:
http://www.spinics.net/lists/linux-tegra/msg14108.html

Wei Ni (2):
  hwmon: (lm90) split set&show temp as common codes
  hwmon: lm90: expose to thermal fw via DT nodes

 drivers/hwmon/lm90.c |  228 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 173 insertions(+), 55 deletions(-)

-- 
1.7.9.5


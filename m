Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaIDPr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:47:59 -0400
Received: from relais.videotron.ca ([24.201.245.36]:60017 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaIDPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:47:57 -0400
X-Greylist: delayed 918 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 11:47:57 EDT
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v2 0/2] sched/idle : find the best idle CPU with cpuidle info
Date: Thu, 04 Sep 2014 11:32:08 -0400
Message-id: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rework of the series initially posted by Daniel Lezcano here:

http://news.gmane.org/group/gmane.linux.power-management.general/thread=44161

Those patches were straightened up, commit logs are more comprehensive,
bugs were fixed, etc.


 drivers/cpuidle/cpuidle.c |  6 ++++++
 kernel/sched/fair.c       | 43 ++++++++++++++++++++++++++++++++++-------
 kernel/sched/idle.c       |  6 ++++++
 kernel/sched/sched.h      | 39 +++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 7 deletions(-)


Nicolas


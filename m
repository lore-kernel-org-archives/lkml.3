Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3KFMIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:08:23 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:51883 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756580Ab3KFMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:08:21 -0500
From: Vinayak Kale <vkale@apm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: tglx@linutronix.de, will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        Vinayak Kale <vkale@apm.com>
Subject: [PATCH 0/2] genirq: arm64: perf: support for percpu pmu interrupt
Date: Wed,  6 Nov 2013 17:37:35 +0530
Message-Id: <1383739658-10036-1-git-send-email-vkale@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support to handle interrupt registration/deregistration
in arm64 pmu driver when pmu interrupt type is percpu.

Patches in this patch series were previously sent out as separate patches [1].
This patch series incorporates comments/fixes suggested for original patches.

[1] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/205888.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204414.html 

Vinayak Kale (2):
  genirq: error reporting in request_percpu_irq() and
    request_threaded_irq()
  arm64: perf: add support for percpu pmu interrupt

 arch/arm64/kernel/perf_event.c |  109 +++++++++++++++++++++++++++++-----------
 kernel/irq/manage.c            |   12 +++--
 2 files changed, 89 insertions(+), 32 deletions(-)

-- 
1.7.9.5


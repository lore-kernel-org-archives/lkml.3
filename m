Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaCLMkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:40:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43427 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaCLMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:40:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, b.zolnierkie@samsung.com,
        linux-ide@vger.kernel.org
Subject: [PATCH 0/5] ahci: st: Apply Bartlomiej's suggestions 
Date: Wed, 12 Mar 2014 12:39:37 +0000
Message-Id: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Sorry for the delay, I was in Asia for 9 days last week.

Here are the suggestions from Bartlomiej's review.

 drivers/ata/Kconfig   |  8 ++++----
 drivers/ata/ahci_st.c | 54 ++++++++++++++++++++++++++++++++----------------------
 2 files changed, 36 insertions(+), 26 deletions(-)


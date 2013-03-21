Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab3CUN3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:29:00 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:59355 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab3CUN26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:28:58 -0400
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com, rjw@sisk.pl, Kevin Hilman <khilman@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH 0/2] Add devfreq runtime pm support
Date: Thu, 21 Mar 2013 18:58:24 +0530
Message-Id: <1363872506-3630-1-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to bind devfreq to runtime pm framework. The device
devfreq is  automatically suspended with pm_runtime_suspend()
and resumed with pm_runtime_resume().

Discussed at http://comments.gmane.org/gmane.linux.linaro.devel/13787

Rajagopal Venkat (2):
  PM / devfreq: Fix compiler warnings
  PM / devfreq: tie suspend/resume to runtime-pm

 drivers/base/power/runtime.c |   18 ++++++++++++++-
 drivers/devfreq/devfreq.c    |   51 ++++++++++++++++++++++++++++++++++++++----
 include/linux/devfreq.h      |   30 +++++++++----------------
 include/linux/pm.h           |    2 ++
 4 files changed, 76 insertions(+), 25 deletions(-)

-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598Ab3BNTgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:36:11 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34282 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab3BNTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:36:09 -0500
From: Benson Leung <bleung@chromium.org>
To: len.brown@intel.com, colin.king@canonical.com,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, vapier@gentoo.org
Subject: [PATCH v3 1/1] tools/power x86_energy_perf_policy: fix cpuid for i686
Date: Thu, 14 Feb 2013 11:35:57 -0800
Message-Id: <1360870558-11711-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Please take a look at this patch to the x86_energy_perf_policy that allows
the tool to work when built for i686 with PIC enabled.

Thanks,
Benson


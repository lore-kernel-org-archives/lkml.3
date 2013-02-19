Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab3BSUSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:18:43 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40944 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3BSUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:18:41 -0500
From: Benson Leung <bleung@chromium.org>
To: len.brown@intel.com, colin.king@canonical.com,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, vapier@gentoo.org
Subject: [PATCH v4 0/1] tools/power x86_energy_perf_policy: fix cpuid for i686
Date: Tue, 19 Feb 2013 12:18:32 -0800
Message-Id: <1361305113-5627-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360870558-11711-1-git-send-email-bleung@chromium.org>
References: <1360870558-11711-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Len and Mike for your comments. I've fixed the style problems so this
is now checkpatch clean.

I've also moved to Mike's better cpuid from ltp.

Thanks,
Benson


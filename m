Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab3B0GIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:08:18 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46278 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3B0GIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:08:00 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Android Kernel Team <kernel-team@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Nick Kralevich <nnk@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Charndeep Grewal <csgrewa@tycho.ncsc.mil>
Subject: [PATCH 0/5] staging: Updates from the Android tree (for 3.10)
Date: Tue, 26 Feb 2013 22:07:33 -0800
Message-Id: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,
	I was looking over the current Android tree and noticed there
were a few updates that should be pushed into staging so upstream stays
in sync with what Android is using. I've already checked with the folks
at Google (cc'ed) and they had no objections to sending these to you.

Let me know if you have any objections or comments.

thanks
-john

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Charndeep Grewal <csgrewa@tycho.ncsc.mil>

Arve Hjønnevåg (3):
  staging: android: lowmemorykiller: Add config option to support
    oom_adj values
  staging: android: lowmemorykiller: Don't count reserved free memory
  staging: android: lowmemorykiller: Change default debug_level to 1

Charndeep Grewal (1):
  staging: android: logger: enforce GID and CAP check on log flush

Nick Kralevich (1):
  staging: android: logger: Allow a UID to read it's own log entries

 drivers/staging/android/Kconfig           |    9 ++
 drivers/staging/android/logger.c          |  196 +++++++++++++++++++++++++----
 drivers/staging/android/logger.h          |   40 +++++-
 drivers/staging/android/lowmemorykiller.c |   90 ++++++++++++-
 4 files changed, 304 insertions(+), 31 deletions(-)

-- 
1.7.10.4


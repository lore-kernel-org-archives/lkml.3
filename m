Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3HVOxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:53:17 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58749 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3HVOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:53:16 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 0/3] clean up echo -e usage
Date: Thu, 22 Aug 2013 18:53:03 +0400
Message-Id: <1377183186-8407-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up non-portable 'echo -e' usage.
I haven't replaced all instances of 'echo -e' though:
- those under Documentation don't affect build;
- those that invoke echo by full path (/bin/echo) probably know what they do;
- those that output user help don't affect build.

Max Filippov (3):
  xtensa: don't use echo -e needlessly
  x86: don't use echo -e needlessly
  raid6/test: replace echo -e with printf

 arch/x86/Makefile         |    2 +-
 arch/xtensa/Makefile      |    4 ++--
 arch/xtensa/boot/Makefile |    2 +-
 lib/raid6/test/Makefile   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.7.7.6


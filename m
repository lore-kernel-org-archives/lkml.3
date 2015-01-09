Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbbAIPKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:10:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377AbbAIPKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:10:16 -0500
From: Michal Marek <mmarek@suse.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-dev-en@lists.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tomoyo Makefile cleanup
Date: Fri,  9 Jan 2015 16:08:51 +0100
Message-Id: <1420816134-12758-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tomoyo build leaves files in security/tomoyo which are not removed
by make clean. Fix this and clean up the Makefile rules a bit.

Michal Marek (3):
  tomoyo: Use bin2c to generate builtin-policy.h
  tomoyo: Use if_changed when generating builtin-policy.h
  tomoyo: Do not generate empty policy files

 security/tomoyo/.gitignore                         |  2 +-
 security/tomoyo/Kconfig                            |  1 +
 security/tomoyo/Makefile                           | 55 +++++-----------------
 .../tomoyo/policy/exception_policy.conf.default    |  2 +
 4 files changed, 15 insertions(+), 45 deletions(-)
 create mode 100644 security/tomoyo/policy/exception_policy.conf.default

-- 
2.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbaELNVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:21:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:28989 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbaELNVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:21:40 -0400
X-Nat-Received: from [202.181.97.72]:55641 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1399900888.3649
To: miklos@szeredi.hu, jmorris@namei.org, john.johansen@canonical.com,
        selinux@tycho.nsa.gov
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH (for 3.15) 0/5] Fix cross rename regressions for LSM.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
	<201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>
In-Reply-To: <201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>
Message-Id: <201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 12 May 2014 22:21:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 12052014 #7893288, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from previous patchset.

  Clarified that this is a regression fix.
  AppArmor: Pass appropriate inode's mode to aa_path_perm().
  TOMOYO: Changed "file swapname" permission to "file exchange" permission.

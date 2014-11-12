Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaKLFl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:41:56 -0500
Received: from ozlabs.org ([103.22.144.67]:50689 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaKLFly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:41:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: stable@vger.kernel.org
Subject: [PULL] params fix
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Nov 2014 16:09:03 +1030
Message-ID: <87ppctm0zs.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git 

for you to fetch changes up to 3438cf549d2f3ee8e52c82acc8e2a9710ac21a5b:

  param: fix crash on bad kernel arguments (2014-11-11 17:03:19 +1030)

----------------------------------------------------------------
Daniel Thompson (1):
      param: fix crash on bad kernel arguments

 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

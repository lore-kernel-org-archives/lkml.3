Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaJPXQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:16:09 -0400
Received: from ozlabs.org ([103.22.144.67]:49218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbaJPXQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:16:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PULL] One modules patch
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Oct 2014 09:43:30 +1030
Message-ID: <87oatba9r9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 184c3fc3f52fb75800deb76deffb70907d1f76ea:

  moduleparam: Resolve missing-field-initializer warning (2014-09-11 09:59:25 +0930)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/modules-next-for-linus

for you to fetch changes up to d3051b489aa81ca9ba62af366149ef42b8dae97c:

  modules, lock around setting of MODULE_STATE_UNFORMED (2014-10-15 10:20:09 +1030)

----------------------------------------------------------------
A single panic fix for a rare race, stable CC'd.

Cheers,
Rusty.

----------------------------------------------------------------
Prarit Bhargava (1):
      modules, lock around setting of MODULE_STATE_UNFORMED

 kernel/module.c | 2 ++
 1 file changed, 2 insertions(+)

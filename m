Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3KSOmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KSOmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:01 -0500
Date: Tue, 19 Nov 2013 15:43:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>, Petr Matousek <pmatouse@redhat.com>,
        Vasily Kulikov <segoon@openwall.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] get/set_dumpable() cleanups and theoretical fix
Message-ID: <20131119144300.GA28842@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The only change is WARN_ON() in 2/3 to catch the insane callers,
I preserved the acks from Kees.

Oleg.

 fs/coredump.c         |    1 -
 fs/coredump.h         |    6 ----
 fs/exec.c             |   62 ++++++------------------------------------------
 include/linux/sched.h |   25 ++++++++++++++-----
 4 files changed, 26 insertions(+), 68 deletions(-)


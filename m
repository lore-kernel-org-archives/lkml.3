Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab3FCUuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:50:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223Ab3FCUuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:50:16 -0400
Date: Mon, 3 Jun 2013 22:45:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Guy Streeter <streeter@redhat.com>, Eric Paris <eparis@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/1] audit: cleanup audit_log_start/wait_for_auditd mess
Message-ID: <20130603204559.GA21574@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Really, audit_log_start/wait_for_auditd look so ugly imho, I simply
can't resist. Compile-tested only, I do not know how to use audit,
but I think the code is really simple after this cleanup.

On top of audit-wait_for_auditd-should-use-task_uninterruptible.patch

Oleg.


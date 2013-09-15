Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3IORQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:16:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176Ab3IORQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:16:54 -0400
Date: Sun, 15 Sep 2013 19:10:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>,
        Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Zach Levis <zml@linux.vnet.ibm.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] audit_alloc: clear TIF_SYSCALL_AUDIT if
	!audit_context
Message-ID: <20130915171038.GA15410@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

v2:
	- update the changelog

	- add the ack from Steve

Oleg.


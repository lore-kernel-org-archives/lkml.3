Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3HWSEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab3HWSEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:04:43 -0400
Date: Fri, 23 Aug 2013 19:58:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] namespaces && fork fixes/cleanups
Message-ID: <20130823175846.GA30201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

To remind, 1/3 fixes the regression, perhaps it should cc -stable.

v2:
	changed the comment, added the acks from Andy.

Still needs the review from Eric.

Oleg.

 kernel/fork.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)


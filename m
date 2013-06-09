Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab3FIREM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab3FIREK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:04:10 -0400
Date: Sun, 9 Jun 2013 19:00:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] copy_process/attach_pid minor fix + cleanups
Message-ID: <20130609170007.GA5215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

1/4 and 2/4 look like the obvious cleanups.

3/4 tries to fix the minor problem. I have to admit, initially
I thought that this problem is more serious. But it seems that
nothing really bad can happen if the new task has the wrong pid
or group_leader. Still I think this makes sense.

4/4 is offtopic minor cleanup.


This is also another preparation for while_each_thread() fixes.

Oleg.


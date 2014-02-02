Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaBBPFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 10:05:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:37965 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaBBPFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 10:05:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,766,1384329600"; 
   d="scan'208";a="468598205"
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Why is syscall auditing on with no rules?
References: <CALCETrUEZiqQ7be5E7cBEmFEKqvwJ_eCxpE-hiGZ94Hkd4Q54Q@mail.gmail.com>
Date: Sun, 02 Feb 2014 07:05:48 -0800
In-Reply-To: <CALCETrUEZiqQ7be5E7cBEmFEKqvwJ_eCxpE-hiGZ94Hkd4Q54Q@mail.gmail.com>
	(Andy Lutomirski's message of "Sat, 1 Feb 2014 18:32:31 -0800")
Message-ID: <87d2j5wo4z.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On a stock Fedora installation:
>
> $ sudo auditctl -l
> No rules

I noticed the same recently on a recent opensuse. kauditd is running,
even though I uninstalled all audit related userland long before. I'm sure
the evil "make syscalls slow" flag is set too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

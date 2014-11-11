Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaKKSii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:38:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54582 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaKKSih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:38:37 -0500
Date: Tue, 11 Nov 2014 19:38:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Chen Gong <gong.chen@linux.intel.com>, X86 ML <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
 memory errors
Message-ID: <20141111183831.GM31490@pd.tnic>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
 <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
 <20141111114248.GD31490@pd.tnic>
 <CALCETrULeLC3MhqdG5yJKXp9YL6ir3gOO4e9WGt1X3kkKMXdJw@mail.gmail.com>
 <20141111161309.GG31490@pd.tnic>
 <CALCETrWqGkNBCsPr5QLt4dQSH2mwDgN2tfKy7fqVG4ERZW8e2Q@mail.gmail.com>
 <20141111163059.GH31490@pd.tnic>
 <CALCETrX+u-LZV0GGudi8z-VtcY0y7BD8Yk_4BgTA5C5hekVAtQ@mail.gmail.com>
 <20141111182235.GL31490@pd.tnic>
 <CALCETrXEg61hds9g70_OB_9d=kjdsFr5+yRYH4zG2mhw7D0uHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrXEg61hds9g70_OB_9d=kjdsFr5+yRYH4zG2mhw7D0uHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 10:34:46AM -0800, Andy Lutomirski wrote:
> Wagging this particular dog might shake some loose fur off.  If we did
> this for all paranoid entries, then paranoid_userspace could just be
> deleted.  :)

:-)

> > I'd prefer much more to actually have a mechanism to do something to
> > tasks before scheduling them in.
> 
> Like task_work_add?

Ah, there *is* something like that! I knew we would have something - we
always do :-)

Thanks.

/me goes to stare at it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

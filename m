Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaJWSE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:04:56 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33663 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbaJWSEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:04:53 -0400
Date: Thu, 23 Oct 2014 13:05:19 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Bob Liu <lliubbo@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Convert khugepaged to a task_work function
Message-ID: <20141023180519.GE15104@sgi.com>
References: <1414032567-109765-1-git-send-email-athorlton@sgi.com>
 <54494101.6010701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54494101.6010701@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 01:55:13PM -0400, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 10/22/2014 10:49 PM, Alex Thorlton wrote:
> 
> > Alex Thorlton (4): Disable khugepaged thread Add pgcollapse
> > controls to task_struct Convert khugepaged scan functions to work
> > with task_work Add /proc files to expose per-mm pgcollapse stats
> 
> Is it just me, or did the third patch never show up in other people's
> email either?
> 
> I don't see it in my inbox, my lkml folder, my linux-mm folder, or
> on lkml.org

That's, more than likely, my fault.  I seem to be a pro at messing up
with git send-email :/  Everything showed up properly in my e-mail, but
it does look screwy on lkml.org.  I'll double check everything and do a
resend here shortly.

Sorry about that!

- Alex

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3HGC0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 22:26:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47696 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3HGC0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 22:26:18 -0400
X-Spam-Score: -100.8
Message-ID: <5201B00A.4090609@asianux.com>
Date: Wed, 07 Aug 2013 10:25:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kernel/sys.c: for setfsgid(), return the current
 gid when error occurs
References: <5200AD26.8070701@asianux.com> <CAGXu5j+J=y-+wnkXV_wLJnoCOupFGk8GwvHjJz2oWCiZt_oQGQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+J=y-+wnkXV_wLJnoCOupFGk8GwvHjJz2oWCiZt_oQGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 02:36 AM, Kees Cook wrote:
> On Tue, Aug 6, 2013 at 1:00 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> They are 2 related patches for setfsgid().
>>
>> Patch 1 for bug fix: return the current gid when error occurs.
>> Patch 2 for cleaning code: remove useless variable 'old_fsgid'.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> --
>>  kernel/sys.c |   15 +++++----------
>>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> Making a change like this might have dramatic effects. So, a few
> questions, to help better understand:
> 
> How long as the behavior been this way on Linux?
> What is the origin of the documentation that states it differently?
> Do existing userspace tools already depend on the current behavior?
> What specific problem will be solved by changing this?
> 

Firstly, your questions are necessary and valuable to get reply.

But sorry, I only find it by reading code, and not quite familiar with
the details (e.g. how to use it, and its history ...).

I only know the original implementation has a kernel API related issue
(at least now, it is), and try to send a possible fixing patch to
mailing list for getting more discussion and better fixing.

So, welcome any members to help reply your valuable questions (and I
should also try to answer them, but at least, I really needs time to
familiar about it).


> Thanks,
> 
> -Kees
> 

Thanks.
-- 
Chen Gang

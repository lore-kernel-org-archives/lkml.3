Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaIDFlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:41:51 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50632 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaIDFlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:41:49 -0400
MIME-Version: 1.0
Date: Wed, 3 Sep 2014 22:41:48 -0700
Message-ID: <CAMEtUuz6zraph_8xXW43bNbh5uPRki0yOufMfV5pKMRLhDrQQA@mail.gmail.com>
Subject: Re: [PATCH v9 net-next 2/4] net: filter: split filter.h and expose
 eBPF to user space
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 8:46 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 09/03/2014 05:17 AM, Alexei Starovoitov wrote:
>>
>> allow user space to generate eBPF programs
>>
>> uapi/linux/bpf.h: eBPF instruction set definition
>>
>> linux/filter.h: the rest
>>
>> This patch only moves macro definitions, but practically it freezes
>> existing
>> eBPF instruction set, though new instructions can still be added in the
>> future.
>>
>> These eBPF definitions cannot go into uapi/linux/filter.h, since the names
>> may conflict with existing applications.
>>
>> Full eBPF ISA description is in Documentation/networking/filter.txt
>>
>> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
>
>
> Ok, given you post the remaining two RFCs later on this window as
> you indicate, I have no objections:
>
> Acked-by: Daniel Borkmann <dborkman@redhat.com>

David,

I see that all 4 patches are marked as rfc, whereas I tagged
only 3 and 4 as 'rfc' and mentioned in cover letter that they
will be coming for real in stage III. Here they support patch 2
and show the future changes to bpf.h file.
Patches 1 and 2 are good to go.
Note that they're on top of Hannes's patch:
http://patchwork.ozlabs.org/patch/385266/
Do you want me to resubmit just first two?

Thanks

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaDDH0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:26:37 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35600 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaDDH0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:26:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
	<CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
Date: Fri, 4 Apr 2014 15:26:32 +0800
Message-ID: <CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
Subject: Re: ktap and ebpf integration
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 2:26 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Thu, Apr 3, 2014 at 6:21 PM, Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>> Hi Alexei,
>>
>> We talked a lot on ktap and ebpf integration in these days,
>> Now I think we can put into deeply to thinking out some
>> technical issues in there.
>>
>> Firstly, I want to make sure you are support this ktap and
>> ebpf integration direction, I aware you have ongoing 'bpf filter'
>> patch set work, which actually overlapping with ktap integration
>> efforts (IMO the interface should be unified and simple for user,
>>  so I think filter debugfs file is not a good interface), so please let
>> me know your answer about this.
>
> I think the more choices users have the better.
> I'll continue with C based filters and you can continue with ktap
> syntax. That's ok. We can share all kernel pieces.

Now I understand that there is no way to integrate ktap and ibpf
in technical point of view, the kernel side and interface is
completely different, and obviously you don't want to change
current per-event filter file based interface and kernel part, that
make impossible to let ktap could integrate or share with ibpf.

Anyway, I think there will don't have any necessary to upstream
ktap any more, I still enjoy the simplicity and flexibility given
by ktap,  and hope there will have a kernel built-in alternative
solution in future.

Specially thanks for the guys which put the efforts on ktap review.

Jovi

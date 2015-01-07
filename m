Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbbAGMlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:41:44 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:51801 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbbAGMlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:41:42 -0500
Message-ID: <54AD2983.2060108@gmail.com>
Date: Wed, 07 Jan 2015 13:41:39 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        ast@plumgrid.com
Subject: Re: Edited seccomp.2 man page for review [v2]
References: <54A29722.1010901@gmail.com>	<CAGXu5j+C0SWQ+CeOb2ADXdsLWorUHahX4UhUg+UGbT6UuWiQFQ@mail.gmail.com>	<54A300D0.7090802@gmail.com> <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg@mail.gmail.com> <54AD1E37.8020509@gmail.com> <54AD2549.9040107@redhat.com>
In-Reply-To: <54AD2549.9040107@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 01:23 PM, Daniel Borkmann wrote:
> On 01/07/2015 12:53 PM, Michael Kerrisk (man-pages) wrote:
> ...
>> Still hoping to hear from Will Drewy regarding this FIXME in the
>> page source:
>>
>> .\" FIXME What is the significance of the line
>> .\"           ftest->code = BPF_LDX | BPF_W | BPF_ABS;
>> .\"       in kernel/seccomp.c::seccomp_check_filter()?
> 
> This came in from our rework via commit bd4cf0ed331a ("net: filter:
> rework/optimize internal BPF interpreter's instruction set"), and
> is kernel-internal only, and unused in classic BPF. It translates
> into A = *(u32 *) (ctx + K) and will basically load an offset from
> the populated seccomp_data (= ctx) to A. For the man-page itself
> it has therefore no relevance, hope that clarifies it.

Thanks, Daniel.

Okay -- that was the last hurdle. The page should go out with the 
next man-pages release.

Cheers,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

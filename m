Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaG1Xyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:54:43 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:45420 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaG1Xyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <53D6E07F.7090806@zytor.com>
References: <cover.1405992946.git.luto@amacapital.net>
	<CAGXu5jJ93-vto9voMENc4jX5itcd_Rm5AZjeChF57fpMYnWocA@mail.gmail.com>
	<CALCETrVwqDeRbFOw=k_OhQZ4V6Pn5v3t8ODw75UuE7HKPFz=Sw@mail.gmail.com>
	<53D68F91.4000106@zytor.com>
	<CAGXu5jKJOrtjY9JsCBUvUbj_y4Hv+AeMEmGwWZZ18FmiZmAbbQ@mail.gmail.com>
	<53D6DE1E.1060501@zytor.com>
	<CAGXu5jLjmHczeQiJN1Q+aGQKn_B+08FEXHWxjku6QedkGDhDTg@mail.gmail.com>
	<53D6E07F.7090806@zytor.com>
Date: Mon, 28 Jul 2014 16:54:38 -0700
X-Google-Sender-Auth: Mcou2ELHP4zx9cJIbdNjhWuAnKk
Message-ID: <CAGXu5jJA=gN+5gQs5wNUdsnqiK3kRVvYnpBB6DkdhmVCsenugQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] Two-phase seccomp and x86 tracing changes
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Will Drewry <wad@chromium.org>, "x86@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 4:45 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/28/2014 04:42 PM, Kees Cook wrote:
>> On Mon, Jul 28, 2014 at 4:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 07/28/2014 04:29 PM, Kees Cook wrote:
>>>> On Mon, Jul 28, 2014 at 10:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>>> On 07/23/2014 12:20 PM, Andy Lutomirski wrote:
>>>>>>
>>>>>> It looks like patches 1-4 have landed here:
>>>>>>
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/fastpath
>>>>>>
>>>>>> hpa, what's the route forward for the x86 part?
>>>>>>
>>>>>
>>>>> I guess I should discuss this with Kees to figure out what makes most
>>>>> sense.  In the meantime, could you address Oleg's question?
>>>>
>>>> Since the x86 parts depend on the seccomp parts, I'm happy if you
>>>> carry them instead of having them land from my tree. Otherwise I'm
>>>> open to how to coordinate timing.
>>>>
>>>
>>> You mean for me to carry the seccomp part as well?
>>
>> If that makes sense as far as the coordination, that's fine with me.
>> Otherwise I'm not sure how x86 can build without having the seccomp
>> changes in your tree.
>>
>
> Exactly.  What I guess I'll do is set up a separate tip branch for this,
> pull your branch into it, and then put the x86 patches on top.  Does
> that make sense for everyone?

Sounds good to me. Once Oleg and Andy are happy, we'll be set.

-Kees


-- 
Kees Cook
Chrome OS Security

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaBUU0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:26:03 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:52942 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaBUU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:26:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140221121944.bb80827b15aa616b07a56912@linux-foundation.org>
References: <5307b218.8VLijuWgRh9icTUZ%akpm@linux-foundation.org>
	<CAGXu5jJrTdD9GzbbSLQbbJJV1=XZbJ6sLpZR3q6mt1OzM8fM6w@mail.gmail.com>
	<20140221121944.bb80827b15aa616b07a56912@linux-foundation.org>
Date: Fri, 21 Feb 2014 12:25:59 -0800
X-Google-Sender-Auth: dMameGCWAuRnr582KnI60Umtsjk
Message-ID: <CAGXu5jJV=0VbT65ozEB8OKJDGQXnjtG5V4vU4WxRJ9CqXFhQYg@mail.gmail.com>
Subject: Re: + makefile-fix-build-with-make-380-again.patch added to -mm tree
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@kernel.org>,
        Jan Beulich <jbeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 21 Feb 2014 12:09:51 -0800 Kees Cook <keescook@chromium.org> wrote:
>
>>
>> This appears to be missing the:
>>
>> -else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
>> +else
>> +ifdef CONFIG_CC_STACKPROTECTOR_STRONG
>>
>> chunk?
>
> Yup, already fixed after my kernel wouldn't compile ;)
>
> It conflicted with
> makefile-fix-extra-parenthesis-typo-when-cc_stackprotector_regular-is-enabled.patch
> and I mucked up the repairs.

Great, thanks!

-Kees

-- 
Kees Cook
Chrome OS Security

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab3AOGRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:17:13 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33382 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3AOGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:17:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU_8ngBbXbwrqC1SaR3fScoDNvO_nKOhDYBV_bjOzjwJg@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-23-git-send-email-yinghai@kernel.org>
	<20130113214132.GB17200@liondog.tnic>
	<CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
	<50F4452D.2060000@zytor.com>
	<CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
	<50F455A3.4070706@zytor.com>
	<CAE9FiQUtbpo0njyPjPED=esKKnSdFs9ry4pFjG1y0LvHxkqV4w@mail.gmail.com>
	<50F46304.3010108@zytor.com>
	<CAE9FiQU_8ngBbXbwrqC1SaR3fScoDNvO_nKOhDYBV_bjOzjwJg@mail.gmail.com>
Date: Mon, 14 Jan 2013 22:17:10 -0800
X-Google-Sender-Auth: IM2kAYbijdXQNlvbfaGl4aNpz1w
Message-ID: <CAE9FiQWxWdeGB-DZp7W2rmukG-KPahF8SQbBcHUWbbUAJA2MhA@mail.gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:05 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jan 14, 2013 at 11:56 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 01/14/2013 11:50 AM, Yinghai Lu wrote:
>>> On Mon, Jan 14, 2013 at 10:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> No, there were other fields that were also left uninitialized, per your
>>>> analysis from last year.  I don't remember the details, but I seem to
>>>> recall they included the EFI and graphics-related fields.
>>>>
>>>> So yes, just zero them all out.
>>>
>>> ?
>>>
>>
>> Yep.
>
> ok, will rebase -v7 branch this afternoon, and ask you and Borislav to
> check if i missed anything.
>
> hope can send out v7u2 tomorrow ...

I rebased the -v7 branch, and it should address the comments and change log
request that I understand and agreed on.

could be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-boot

and it is on top of linus's tree 2013-01-14
plus tip:x86/mm, tip:x86/urgent, tip:x86/mm2

Please check if I miss anything that must be addressed.

Thanks

Yinghai

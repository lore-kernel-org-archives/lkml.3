Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3ANShm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:37:42 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54400 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab3ANShl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:37:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUVkrv3jcCZnrg3=7pXyyfd9d+MJGDqU-dF_+YtB+2-ww@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-24-git-send-email-yinghai@kernel.org>
	<20130114112045.GF1228@liondog.tnic>
	<CAE9FiQUVkrv3jcCZnrg3=7pXyyfd9d+MJGDqU-dF_+YtB+2-ww@mail.gmail.com>
Date: Mon, 14 Jan 2013 10:37:39 -0800
X-Google-Sender-Auth: 85p4AsqabSUzSoHNmkIQarDToUY
Message-ID: <CAE9FiQWPbRRGkycs_oocNcHB+bEcdkqxX9zHfJVmwq_hKgKBOA@mail.gmail.com>
Subject: Re: [PATCH v7u1 23/31] x86, boot: update comments about entries for
 64bit image
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:35 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jan 14, 2013 at 3:20 AM, Borislav Petkov <bp@alien8.de> wrote:
>>> the boot loader should
>>> +also fill the additional fields of the struct boot_params as that
>>
>>                                                         remove "that"
>>
>>> +described in zero-page.txt.
>>
>> Btw, you could document the sentinel mechanism here or in zero-page.txt,
>> for example.
>
>
> that is:
> ---
> The memory for struct boot_params
> could be allocated anywhere (even above 4G) and initialized to all zero.
> ---
>
> bootloader memset zero_page at first means.
> and all bootloader did that except kexec. and it is fixed patches for
> kexec-tools.

also I fix some errors that you mentioned, but not all of them
because I copied 32bit portion to 64bit and modified it.

So you  may submit patch to fix 32bit and 64bit at the same time if you like.

Thanks

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3ALWE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:04:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35756 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab3ALWEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:04:55 -0500
Message-ID: <50F1DDE6.2020105@zytor.com>
Date: Sat, 12 Jan 2013 14:04:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 08/31] x86, 64bit: early #PF handler set page table
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-9-git-send-email-yinghai@kernel.org> <20130107155544.GD29449@x1.alien8.de> <CAE9FiQXcP9E-RXre_NKf-SU454nT9K39f1GsVVroV1TFxPgQ7g@mail.gmail.com> <20130110121922.GF23008@liondog.tnic> <CAE9FiQV9i2D319soGWyS-NwcEM2HH2gzbh_UjxmoijH0z+0mWQ@mail.gmail.com> <20130110202740.GH23008@liondog.tnic>
In-Reply-To: <20130110202740.GH23008@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 12:27 PM, Borislav Petkov wrote:
>>
>> So at that time how can the Signed-off from them?
>>
>> And there are commits in the upstream does not have Signed-off from the Author.
>
> I certainly hope those are a very very small number, if any.
>

There are indeed a handful, at which point the first Signed-off-by: 
indicates that he, *based on his own first-hand knowledge* knows the 
author is intending and allowed to release this patch under the 
appropriate licensing term (see the Developer's Certificate of Origin 
document for the exact details.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


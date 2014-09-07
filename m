Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaIGIth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 04:49:37 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48907 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaIGItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 04:49:35 -0400
Message-ID: <540C1C01.1000308@plexistor.com>
Date: Sun, 07 Sep 2014 11:49:05 +0300
From: Yigal Korman <yigal@plexistor.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, akpm@linuxfoundation.org,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/5] x86, mm: Add set_memory_wt() for WT
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>	 <1409855739-8985-5-git-send-email-toshi.kani@hp.com>	 <CALCETrXjpoVmCi07zo0dKH9LrF+nz9F3GshNiQvmiueFFH=TUQ@mail.gmail.com> <1409857025.28990.125.camel@misato.fc.hp.com>
In-Reply-To: <1409857025.28990.125.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that what confused Andy (or at least me) is the documentation in Documentation/x86/pat.txt
If it's possible, can you please update pat.txt as part of the patch?

Thank you,
Yigal

On 04/09/2014 21:57, Toshi Kani wrote:
> On Thu, 2014-09-04 at 11:57 -0700, Andy Lutomirski wrote:
>> On Thu, Sep 4, 2014 at 11:35 AM, Toshi Kani <toshi.kani@hp.com> wrote:
>>> This patch adds set_memory_wt(), set_memory_array_wt(), and
>>> set_pages_array_wt() for setting range(s) of memory to WT.
>>>
>> Possibly dumb question: I thought that set_memory_xyz was only for
>> RAM.  Is that incorrect?
> It works for non-RAM ranges as well.  For instance, you can use
> set_memory_xyz() to change cache attribute for a non-RAM range mapped by
> ioremap_cache().
>
> Thanks,
> -Toshi
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


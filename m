Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab3FYF1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:27:30 -0400
Received: from mail.lemote.com ([222.92.8.138]:41205 "EHLO mail.lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3FYF12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:27:28 -0400
X-Greylist: delayed 754 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 01:27:28 EDT
Message-ID: <6e5236ab6ef90f42fdc42d3bf4284f58.squirrel@mail.lemote.com>
In-Reply-To: <51C8CA95.80008@imgtec.com>
References: <1359527106-22879-1-git-send-email-chenhc@lemote.com>
    <1359527106-22879-4-git-send-email-chenhc@lemote.com>
    <5166ED66.7020307@realitydiluted.com>
    <CAAhV-H6s47NUHzbEX5UKYtkei7=s08PPXCMw39_fP_SV7Hv5Vg@mail.gmail.com>
    <CAAhV-H58Y_Rd8thj8MWXGCqqGtYJekDKrO-nXYjdp3214jnQ0A@mail.gmail.com>
    <51C8CA95.80008@imgtec.com>
Date: Tue, 25 Jun 2013 13:14:39 +0800
Subject: Re: [PATCH V9 03/13] MIPS: Loongson: Introduce and use
 cpu_has_coherent_cache feature
From: chenhc@lemote.com
To: "Steven J. Hill" <Steven.Hill@imgtec.com>
Cc: "Steven J. Hill" <sjhill@realitydiluted.com>,
        "Ralf Baechle" <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, "Fuxin Zhang" <zhangfx@lemote.com>,
        "Zhangjin Wu" <wuzhangjin@gmail.com>,
        "Hongliang Tao" <taohl@lemote.com>, "Hua Yan" <yanh@lemote.com>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/22/2013 09:10 PM, Huacai Chen wrote:
>>
>> Is the 3rd patch of V10 is OK to be accepted now? If so, could the
>> patchset of V10 be merged into 3.11?
>>
> The merge window for 3.11 is closed at this point. You should get it
> prepared for 3.12, so start tracking the 'mips-for-linux-next' branch
> with your patches.
OK, if the 3rd patch has no problem, I think they can be easily applied
on mips-for-linux-next in future.

>
> Acked-by: Steven J. Hill <Steven.Hill@imgtec.com>
>
>



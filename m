Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3DAGMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:12:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46217 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab3DAGMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:12:34 -0400
Message-ID: <51592541.5080903@ti.com>
Date: Mon, 1 Apr 2013 11:42:17 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] ARM: davinci: use is IS_ENABLED macro
References: <1364210495-7938-1-git-send-email-prabhakar.csengg@gmail.com> <20130327214347.f2a573510416b86223c58be1@canb.auug.org.au> <CA+V-a8urWyzaU-nKh7sumr3tbmswixzWsumVHMpis6=fgD3Z+g@mail.gmail.com>
In-Reply-To: <CA+V-a8urWyzaU-nKh7sumr3tbmswixzWsumVHMpis6=fgD3Z+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/2013 10:07 AM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Wed, Mar 27, 2013 at 4:13 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi,
>>
>> On Mon, 25 Mar 2013 16:51:35 +0530 Prabhakar lad <prabhakar.csengg@gmail.com> wrote:
>>>
>>> --- a/arch/arm/mach-davinci/board-da830-evm.c
>>> +++ b/arch/arm/mach-davinci/board-da830-evm.c
>>> @@ -298,7 +298,7 @@ static const short da830_evm_emif25_pins[] = {
>>>       -1
>>>  };
>>>
>>> -#if defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
>>> +#if IS_ENABLED(CONFIG_MMC_DAVINCI)
>>>  #define HAS_MMC      1
>>>  #else
>>>  #define HAS_MMC      0
>>
>> Why not
>>
>> #define HAS_MMC         IS_ENABLED(CONFIG_MMC_DAVINCI)
>>
>> and similarly in the rest?
>>
> Stephen's suggestion looks good to me, if you haven’t queued it i'll post a v2,
> or if you have already queued it I'll create a patch on top of the
> same patch fixing it.
> lemme know how would you want it.

Please post a v2. I will take that instead.

Thanks,
Sekhar

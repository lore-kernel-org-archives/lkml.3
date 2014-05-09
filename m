Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaEIBGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:06:01 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45040 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaEIBF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:05:59 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s4915H3N000491, This message is accepted by code: ctloc85258
Message-ID: <536C2AD0.7020104@realsil.com.cn>
Date: Fri, 9 May 2014 09:09:36 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>, Lee Jones <lee.jones@linaro.org>
CC: Chris Ball <chris@printf.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/2] mmc: rtsx: Revert "mmc: rtsx: modify errorhandleandremovesmatch warnings"
References: <cover.1398735435.git.micky_ching@realsil.com.cn>	<1076b1824732688774d223a14595ecf26a375d82.1398735435.git.micky_ching@realsil.com.cn>	<CAPDyKFoZ2_H6Jh0+84zLBhayMb0=q1eJw=vC_m41iCsbz0siFw@mail.gmail.com>	<536B1B05.6010604@realsil.com.cn>	<20140508075542.GC5307@lee--X1> <CAPDyKFqU+7NoZ1JjKa2YMj2DJsuBG5jD8fEt7WdLawA-mmqOjw@mail.gmail.com>
In-Reply-To: <CAPDyKFqU+7NoZ1JjKa2YMj2DJsuBG5jD8fEt7WdLawA-mmqOjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf

On 05/08/2014 04:22 PM, Ulf Hansson wrote:
> On 8 May 2014 09:55, Lee Jones <lee.jones@linaro.org> wrote:
>>> It seems Chris is too busy to responding, so would you help to pick
>>> this patch for 3.15 fix.
>> Hmmmm... that's pretty bad timing.  I've literally just sent the
>> pull-request containing the MFD/MMC fixup branch to Linus.  I guess
>> Ulf will have to do it.
> There seem to be some confusion here. :-)
>
> This patch is _only_ intended for Chris' mmc_next branch, so it
> shouldn't go for 3.15 fixes. Or better, Chris should drop the patch
> this one is reverting.
Sorry for the mistake, only the second patch of the patch set is need 
for 3.15 fix.
I wrote this email in a wrong place.

Best Regards.
> Likely we will see a merge problem in Stephen Rothwell's linux-next
> tree, until Chris' drops this patch - causing Stephen to not merge the
> mmc tree for a while. I suppose that's the best we can do, until Chris
> shows up again.
>
> Kind regards
> Ulf Hansson
>
>>>>>> From: Micky Ching<micky_ching@realsil.com.cn>
>>>>>>
>>>>>> This reverts commit 1f7b581b3ffcb2a8437397a02f4af89fa6934d08.
>>>>>>
>>>>>> The patch depend on commit c42deffd5b53c9e583d83c7964854ede2f12410d
>>>>>> <mmc: rtsx: add support for pre_req and post_req>, but the previous
>>>>>> patch was discard. So we have to delete the patch.
>>>>>>
>>>>>> Signed-off-by: Micky Ching<micky_ching@realsil.com.cn>
>>>> Acked-by: Ulf Hansson<ulf.hansson@linaro.org>
>> --
>> Lee Jones
>> Linaro STMicroelectronics Landing Team Lead
>> Linaro.org │ Open source software for ARM SoCs
>> Follow Linaro: Facebook | Twitter | Blog
> .
>


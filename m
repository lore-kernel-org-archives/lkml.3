Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaCZB00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 21:26:26 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50219 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaCZB0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 21:26:25 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2Q1Ptau005049, This message is accepted by code: ctloc85258
Message-ID: <53322D81.3050701@realsil.com.cn>
Date: Wed, 26 Mar 2014 09:29:37 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 0/2] mmc: rtsx: add new cmd type handle and modify errorhandle
References: <cover.1395625491.git.micky_ching@realsil.com.cn> <CAPDyKFrk-7msEVcYzY5Vc+ZODtMbiCWGAMU7G2oscgN1Ad9URA@mail.gmail.com>
In-Reply-To: <CAPDyKFrk-7msEVcYzY5Vc+ZODtMbiCWGAMU7G2oscgN1Ad9URA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,
On 03/25/2014 06:44 PM, Ulf Hansson wrote:
> On 25 March 2014 10:47,  <micky_ching@realsil.com.cn> wrote:
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> Add new command type(R1 without CRC) handle, without this
>> patch mmc card initialize will be failed.
>>
>> Using a more careful handle in request timeout, this would
>> improve error recover capability. Debug info is printed
>> using non DMA mode, this would help print more accurately
>> for DMA command failed. Smatch warning was removed.
> Hi Micky,
>
> Seems like this patchset has been around for some time, sorry for the delay.
>
> I don't have any objections to it getting merged, but you need to run
> checkpatch of your patches. Patch2 has a warning you should fix.
Patch2 is based on <mmc: rtsx: fix bug and support nonblocking request>
see: https://lkml.org/lkml/2014/2/17/270
checkpatch.pl seems ok, is there any thing I need to check?

Best Regards.
micky.
> Kind regards
> Ulf Hansson
>
>
>> Micky Ching (2):
>>    mmc: rtsx: add R1-no-CRC mmc command type handle
>>    mmc: rtsx: modify error handle and remove smatch warnings
>>
>>   drivers/mmc/host/rtsx_pci_sdmmc.c |  121 ++++++++++++++++++++-----------------
>>   1 file changed, 67 insertions(+), 54 deletions(-)
>>
>> --
>> 1.7.9.5
> .
>


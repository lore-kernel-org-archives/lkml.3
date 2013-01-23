Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3AWBY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:24:56 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:34258 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3AWBYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:24:54 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0N1Nuh8008249, This message is released by code: ctaloc0852
Message-ID: <50FF3BAD.4010009@realsil.com.cn>
Date: Wed, 23 Jan 2013 09:23:57 +0800
From: pclinux <pclinux@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: =?GB2312?B?zfXsvw==?= <wei_wang@realsil.com.cn>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "oakad@yahoo.com" <oakad@yahoo.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 0/8] rtsx patchset for MFD and MMC tree
References: <cover.1357638064.git.wei_wang@realsil.com.cn> <50F66CAD.6090003@realsil.com.cn> <20130122033115.GY7409@sortiz-mobl> <50FE09DD.6070102@realsil.com.cn> <20130122224232.GC5151@sortiz-mobl>
In-Reply-To: <20130122224232.GC5151@sortiz-mobl>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月23日 06:42, Samuel Ortiz 写道:
> On Tue, Jan 22, 2013 at 11:39:09AM +0800, wwang wrote:
>>>>> Wei WANG (8):
>>>>>   MFD:rtsx: Fix typo in comment
>>>>>   MFD:rtsx: Remove redundant code
>>>>>   MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
>>>>>   MFD:rtsx: Add callback function switch_output_voltage
>>>>>   MMC:rtsx: Using callback function to switch output voltage
>>>>>   MFD:rtsx: Add callback function conv_clk_and_div_n
>>>>>   MFD:rtsx: Fix checkpatch warning
>>>>>   MFD:rtsx: Use macro defines to replace some variables
>>>>>
>>>>>  drivers/mfd/rtl8411.c             |   29 ++++++++++++++++++++++++
>>>>>  drivers/mfd/rts5209.c             |   21 +++++++++++++++++
>>>>>  drivers/mfd/rts5229.c             |   21 +++++++++++++++++
>>>>>  drivers/mfd/rtsx_pcr.c            |   45 +++++++++++++++++++++++++------------
>>>>>  drivers/mfd/rtsx_pcr.h            |    3 +++
>>>>>  drivers/mmc/host/rtsx_pci_sdmmc.c |   30 +++++--------------------
>>>>>  include/linux/mfd/rtsx_common.h   |    3 +++
>>>>>  include/linux/mfd/rtsx_pci.h      |   27 +++++++++++++++++-----
>>>>>  8 files changed, 135 insertions(+), 44 deletions(-)
>>>>>
>>>> Hi Chris and Samuel:
>>>>
>>>> This patchset is trying to fix some bugs and some coding style issues.
>>>> Would you please help to merge it to v3.8 kernel?
>>> I'll only take bug fixes for 3.8, even minor ones, and I don't see real bug
>>> fixes here. Am I missing something ?
>>>
>>> Cheers,
>>> Samuel.
>>>
>> Hi Samuel:
>>
>> The commits below are all bug fix ( fix rtl8411 specifically)
>>
>>   MFD:rtsx: Add callback function switch_output_voltage
>>   MMC:rtsx: Using callback function to switch output voltage
>>   MFD:rtsx: Add callback function conv_clk_and_div_n
> Would you mind building a separate patchset for those 3, against e.g. a
> vanilla 3.8-rc4 kernel ? Otherwise they won't apply cleanly against my
> for-linus tree.
>
> Cheers,
> Samuel.
>
Hi Samuel:

Sure. I will do it.
Does it mean that the other commits only can be submitted to 3.9-rc?

BR,
Wei WANG

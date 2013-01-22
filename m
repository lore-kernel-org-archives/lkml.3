Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3AVDjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:39:54 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47391 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3AVDjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:39:52 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0M3d9SA018187, This message is released by code: ctaloc0852
Message-ID: <50FE09DD.6070102@realsil.com.cn>
Date: Tue, 22 Jan 2013 11:39:09 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "oakad@yahoo.com" <oakad@yahoo.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 0/8] rtsx patchset for MFD and MMC tree
References: <cover.1357638064.git.wei_wang@realsil.com.cn> <50F66CAD.6090003@realsil.com.cn> <20130122033115.GY7409@sortiz-mobl>
In-Reply-To: <20130122033115.GY7409@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月22日 11:31, Samuel Ortiz 写道:
> Hi Wei,
>
> On Wed, Jan 16, 2013 at 05:02:37PM +0800, wwang wrote:
>> 于 2013年01月08日 17:57, 王炜 写道:
>>> From: Wei WANG <wei_wang@realsil.com.cn>
>>>
>>> v2:
>>> 1. Add commit message for patch 2
>>> 2. Move pci_set_dma_mask before the pci_enable_device(pcidev) call
>>>
>>> v3:
>>> 1. Add commit message for patch 3
>>> 2. Add patch 8: Use macro defines to replace some variables
>>>
>>> v4:
>>> 1. Describe why patch 3 is needed
>>> 2. Modify a comment character in patch 7
>>>
>>> Wei WANG (8):
>>>    MFD:rtsx: Fix typo in comment
>>>    MFD:rtsx: Remove redundant code
>>>    MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
>>>    MFD:rtsx: Add callback function switch_output_voltage
>>>    MMC:rtsx: Using callback function to switch output voltage
>>>    MFD:rtsx: Add callback function conv_clk_and_div_n
>>>    MFD:rtsx: Fix checkpatch warning
>>>    MFD:rtsx: Use macro defines to replace some variables
>>>
>>>   drivers/mfd/rtl8411.c             |   29 ++++++++++++++++++++++++
>>>   drivers/mfd/rts5209.c             |   21 +++++++++++++++++
>>>   drivers/mfd/rts5229.c             |   21 +++++++++++++++++
>>>   drivers/mfd/rtsx_pcr.c            |   45 +++++++++++++++++++++++++------------
>>>   drivers/mfd/rtsx_pcr.h            |    3 +++
>>>   drivers/mmc/host/rtsx_pci_sdmmc.c |   30 +++++--------------------
>>>   include/linux/mfd/rtsx_common.h   |    3 +++
>>>   include/linux/mfd/rtsx_pci.h      |   27 +++++++++++++++++-----
>>>   8 files changed, 135 insertions(+), 44 deletions(-)
>>>
>> Hi Chris and Samuel:
>>
>> This patchset is trying to fix some bugs and some coding style issues.
>> Would you please help to merge it to v3.8 kernel?
> I'll only take bug fixes for 3.8, even minor ones, and I don't see real bug
> fixes here. Am I missing something ?
>
> Cheers,
> Samuel.
>
Hi Samuel:

The commits below are all bug fix ( fix rtl8411 specifically)

   MFD:rtsx: Add callback function switch_output_voltage
   MMC:rtsx: Using callback function to switch output voltage
   MFD:rtsx: Add callback function conv_clk_and_div_n

The other commits are for coding style issues

BR,
Wei WANG


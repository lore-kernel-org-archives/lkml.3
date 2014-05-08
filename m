Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaEHFq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:46:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:40723 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaEHFq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:46:26 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s485jqS4026454, This message is accepted by code: ctloc85258
Message-ID: <536B1B05.6010604@realsil.com.cn>
Date: Thu, 8 May 2014 13:49:57 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 1/2] mmc: rtsx: Revert "mmc: rtsx: modify error handleandremove smatch warnings"
References: <cover.1398735435.git.micky_ching@realsil.com.cn>	<1076b1824732688774d223a14595ecf26a375d82.1398735435.git.micky_ching@realsil.com.cn> <CAPDyKFoZ2_H6Jh0+84zLBhayMb0=q1eJw=vC_m41iCsbz0siFw@mail.gmail.com>
In-Reply-To: <CAPDyKFoZ2_H6Jh0+84zLBhayMb0=q1eJw=vC_m41iCsbz0siFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee

It seems Chris is too busy to responding, so would you help to pick this 
patch for 3.15 fix.

Best Regards.
micky.
On 04/29/2014 03:30 PM, Ulf Hansson wrote:
> On 29 April 2014 03:54,<micky_ching@realsil.com.cn>  wrote:
>> >From: Micky Ching<micky_ching@realsil.com.cn>
>> >
>> >This reverts commit 1f7b581b3ffcb2a8437397a02f4af89fa6934d08.
>> >
>> >The patch depend on commit c42deffd5b53c9e583d83c7964854ede2f12410d
>> ><mmc: rtsx: add support for pre_req and post_req>, but the previous
>> >patch was discard. So we have to delete the patch.
>> >
>> >Signed-off-by: Micky Ching<micky_ching@realsil.com.cn>
> Acked-by: Ulf Hansson<ulf.hansson@linaro.org>


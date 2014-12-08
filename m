Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaLHKVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:21:08 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39967 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaLHKVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:21:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141208095746.GG3951@x1>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
	<17ba65f4bdf4707bdf038e407ecf5dc012bca281.1417758564.git.micky_ching@realsil.com.cn>
	<20141208095746.GG3951@x1>
Date: Mon, 8 Dec 2014 11:21:06 +0100
Message-ID: <CAPDyKFpt2yT2o159_uX+3RxxpnP=J1SotW58s220SkJSni7PHw@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] mfd: rtsx: add func to split u32 into register
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: micky <micky_ching@realsil.com.cn>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2014 at 10:57, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 05 Dec 2014, micky_ching@realsil.com.cn wrote:
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> Add helper function to write u32 to registers, if we want to put u32
>> value to 4 continuous register, this can help us reduce tedious work.
>>
>> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  include/linux/mfd/rtsx_pci.h | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>
> Applied, thanks.

Lee,

I suppose you queued this for 3.19?

I don't intend to queue anything more before the merge window and thus
the mmc patches can later be handled without any dependence to mfd, I
guess!?

Kind regards
Uffe

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaLHNBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:01:11 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54706 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaLHNBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:01:09 -0500
Date: Mon, 8 Dec 2014 13:01:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: micky <micky_ching@realsil.com.cn>, Samuel Ortiz <sameo@linux.intel.com>,
        Chris Ball <chris@printf.net>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v4 1/6] mfd: rtsx: add func to split u32 into register
Message-ID: <20141208130103.GM3951@x1>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
 <17ba65f4bdf4707bdf038e407ecf5dc012bca281.1417758564.git.micky_ching@realsil.com.cn>
 <20141208095746.GG3951@x1>
 <CAPDyKFpt2yT2o159_uX+3RxxpnP=J1SotW58s220SkJSni7PHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFpt2yT2o159_uX+3RxxpnP=J1SotW58s220SkJSni7PHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2014, Ulf Hansson wrote:

> On 8 December 2014 at 10:57, Lee Jones <lee.jones@linaro.org> wrote:
> > On Fri, 05 Dec 2014, micky_ching@realsil.com.cn wrote:
> >> From: Micky Ching <micky_ching@realsil.com.cn>
> >>
> >> Add helper function to write u32 to registers, if we want to put u32
> >> value to 4 continuous register, this can help us reduce tedious work.
> >>
> >> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> >> Acked-by: Lee Jones <lee.jones@linaro.org>
> >> ---
> >>  include/linux/mfd/rtsx_pci.h | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >
> > Applied, thanks.
> 
> Lee,
> 
> I suppose you queued this for 3.19?
> 
> I don't intend to queue anything more before the merge window and thus
> the mmc patches can later be handled without any dependence to mfd, I
> guess!?

All correct.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

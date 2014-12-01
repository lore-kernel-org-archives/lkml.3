Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaLAMi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:38:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaLAMiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:38:22 -0500
Date: Mon, 1 Dec 2014 15:37:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: micky_ching@realsil.com.cn, ulf.hansson@linaro.org, sameo@linux.intel.com,
        gregkh@linuxfoundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chris@printf.net,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v2 1/2] mfd: rtsx: add func to split u32 into register
Message-ID: <20141201123740.GF4994@mwanda>
References: <cover.1417141102.git.micky_ching@realsil.com.cn>
 <6a6de978f479758fb9e767d8a6e013e8a006a39a.1417141102.git.micky_ching@realsil.com.cn>
 <20141201121858.GA11932@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201121858.GA11932@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 12:18:58PM +0000, Lee Jones wrote:
> On Fri, 28 Nov 2014, micky_ching@realsil.com.cn wrote:
> 
> > From: Micky Ching <micky_ching@realsil.com.cn>
> > 
> > Add helper function to write u32 to registers, if we want to put u32
> > value to 4 continuous register, this can help us reduce tedious work.
> > 
> > Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> > ---
> >  include/linux/mfd/rtsx_pci.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> 
> Does this supersede patch Dan was commenting on?
> 

Yes.

regards,
dan carpenter



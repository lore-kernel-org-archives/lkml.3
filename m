Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaKQO5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:57:03 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44118 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaKQO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:56:59 -0500
Date: Mon, 17 Nov 2014 14:56:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>, laurentiu.palcu@intel.com,
        johan@kernel.org, julia.lawall@lip6.fr, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: dln2: simplify return flow for dln2_i2c_enable
Message-ID: <20141117145651.GR24004@x1>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
 <1415708457-18798-3-git-send-email-octavian.purdila@intel.com>
 <20141113162315.GC1275@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141113162315.GC1275@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Wolfram Sang wrote:

> On Tue, Nov 11, 2014 at 02:20:57PM +0200, Octavian Purdila wrote:
> > This fixes the following kbuild test robot warning:
> > 
> > >> drivers/i2c/busses/i2c-dln2.c:70:1-4: WARNING: end returns can be simplified if negative or 0 value
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> > 
> > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> 
> Acked-by: Wolfram Sang <wsa@the-dreams.de>
> 
> Lee, I think it is easiest if you simply add it to the branch you have
> for this driver. OK?

Octavian indicated that he needs to send a v2 of the second patch.  I
assume he will add your Ack to this patch when he does with a note
saying that it needs to be added to the I2C IB.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

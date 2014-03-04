Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaCDHFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:05:22 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59364 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaCDHFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:05:20 -0500
Date: Tue, 4 Mar 2014 15:05:12 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-ID: <20140304070512.GC10579@lee--X1>
References: <20140211132552.68b0802fd8742c6d72dfa738@canb.auug.org.au>
 <20140304140318.06e7a535ed06e9432e5df7d9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140304140318.06e7a535ed06e9432e5df7d9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

> > After merging the mfd-lj tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/mfd/tps65218: struct i2c_device_id is 32 bytes.  The last of 1 is:
> > 0x74 0x70 0x73 0x36 0x35 0x32 0x31 0x38 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xf0 0x00 0x00 0x00 0x00 0x00 0x00 0x00 
> > FATAL: drivers/mfd/tps65218: struct i2c_device_id is not terminated with a NULL entry!
> > 
> > Caused by commit cc493e30e3a1 ("mfd: tps65218: Add driver for the
> > TPS65218 PMIC").
> 
> Now that the otherproblem is fixed, I am getting this one again :-(

That's annoying. I thought I'd built all of the new drivers.

> > I have used the mfd-lj tree from next-20140210 for today.
> 
> Again.

Sorry, again.

/me investigates.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

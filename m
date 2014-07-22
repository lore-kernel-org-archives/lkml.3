Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaGVNsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:48:32 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52276 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaGVNsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:48:31 -0400
Date: Tue, 22 Jul 2014 14:48:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 09/19] mfd: ezx-pcap: Repair coding style errors picked
 up with checkpatch
Message-ID: <20140722134824.GE16065@lee--X1>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
 <1406027485-15657-10-git-send-email-lee.jones@linaro.org>
 <1406036038.30871.19.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406036038.30871.19.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Joe Perches wrote:

> On Tue, 2014-07-22 at 12:11 +0100, Lee Jones wrote:
> > This is part of an effort to clean-up the MFD subsystem.
> > 
> > WARNING: Missing a blank line after declarations
> > +       u32 flags;
> > +       void (*callback)(void *, u16[]);
> 
> False positive from an old version of checkpatch.
> 
> The one in -next doesn't emit this as it's
> simply a function pointer declaration.

Thanks Joe, will fix up.

> > diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> []
> > @@ -25,8 +25,9 @@ struct pcap_adc_request {
> >  	u8 bank;
> >  	u8 ch[2];
> >  	u32 flags;
> > -	void (*callback)(void *, u16[]);
> >  	void *data;
> > +
> > +	void (*callback)(void *, u16[]);
> >  };
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

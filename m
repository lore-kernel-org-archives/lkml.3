Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaCCHXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:23:43 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44934 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaCCHXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:23:42 -0500
Date: Mon, 3 Mar 2014 15:23:31 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-ID: <20140303072331.GB4674@lee--X1>
References: <20140214134217.aa7e1994b4cab7ee563c8307@canb.auug.org.au>
 <20140217141446.454ab86eb19621fd397be6ed@canb.auug.org.au>
 <20140220150508.79bfff95fb5d93c651801ffd@canb.auug.org.au>
 <20140225143246.914c9732966764234bc51de2@canb.auug.org.au>
 <20140303161803.ecbd9b124b5f2cdf79b8cf51@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140303161803.ecbd9b124b5f2cdf79b8cf51@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> > > > > After merging the mfd-lj tree, today's linux-next build (x86_64
> > > > > allmodconfig) failed like this:
> > > > > 
> > > > > In file included from drivers/mfd/max665x.c:19:0:
> > > > > include/linux/mfd/max665x-private.h:31:1: error: expected ';', identifier or '(' before 'struct'
> > > > >  struct max665x_dev {
> > > > >  ^
> > > > > 
> > > > > Caused by commit e77bb5297293 ("mfd: max665x: Differentiate between
> > > > > MAX665X devices").  Clearly never built by anyone :-(
> > > > > 
> > > > > I have used the mfd-lj tree from next-20140210 again for today (since the
> > > > > other version had other problems).
> > > > 
> > > > Still seeing this error.
> > > 
> > > Still ...
> > 
> > Ping ...
> 
> I am still seeing this error which means that I am still using the
> version of your tree from next-20140210 i.e. Feb 10.  It is a bit
> disappointing that his has not been fixed in such a long time even though
> there have been other updates to your tree which means that those other
> changes have received no exposure in linux-next.  It is a trivial error,
> but it does indicate that noone ever build tested that particular commit.
> 
> (this is now commit 2fc7e7d25bee in your tree since it was rewritten but
> not fixed on Feb 14.)

Sorry about all this. Your mails are being filtered into an unused
mailbox for a currently unknown reason. I will investigate this
immediately. It was a mistake to push this patch, I will rectify right
away.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

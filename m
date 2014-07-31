Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaGaHZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:25:52 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34091 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaGaHZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:25:51 -0400
Date: Thu, 31 Jul 2014 08:25:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: URL change for mfd tree?
Message-ID: <20140731072545.GG9030@lee--X1>
References: <20140730092453.089e1094@canb.auug.org.au>
 <20140730071254.GC9030@lee--X1>
 <20140731090116.01e54d15@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140731090116.01e54d15@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Stephen Rothwell wrote:
> On Wed, 30 Jul 2014 08:12:54 +0100 Lee Jones <lee.jones@linaro.org> wrote:
> >
> > > I noticed commit 71e297b17bb6 ("MAINTAINERS: Update MFD repo location")
> > > in the mfd-lj tree today.  In linux-next, I have the following mfd
> > > trees:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git#master
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git#master
> > > git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git#for-mfd-next
> > > 
> > > Does your commit mean that I should remove the first two?
> > 
> > Yes please.  They haven't been used for ~6 months and aren't likely to
> > be used again.
> 
> I have removed them and renamed mfd-lj to mfd.

Perfect, much obliged.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

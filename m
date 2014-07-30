Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaG3HNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:13:02 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:46229 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaG3HM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:12:59 -0400
Date: Wed, 30 Jul 2014 08:12:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: URL change for mfd tree?
Message-ID: <20140730071254.GC9030@lee--X1>
References: <20140730092453.089e1094@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140730092453.089e1094@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> I noticed commit 71e297b17bb6 ("MAINTAINERS: Update MFD repo location")
> in the mfd-lj tree today.  In linux-next, I have the following mfd
> trees:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git#master
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git#master
> git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git#for-mfd-next
> 
> Does your commit mean that I should remove the first two?

Yes please.  They haven't been used for ~6 months and aren't likely to
be used again.

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

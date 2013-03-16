Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3CPDxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:53:16 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35597 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3CPDxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:53:15 -0400
Date: Fri, 15 Mar 2013 20:54:19 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Li, Fei" <fei.li@intel.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>
Subject: Re: [PATCH] pm: print the name of failed suspend function for
 platform device
Message-ID: <20130316035419.GA12634@kroah.com>
References: <1360041183.15311.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <27240C0AC20F114CBF8149A2696CBE4A254DD3@SHSMSX101.ccr.corp.intel.com>
 <20130315192024.GB11988@kroah.com>
 <27240C0AC20F114CBF8149A2696CBE4A25BE7A@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A25BE7A@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sat, Mar 16, 2013 at 01:22:31AM +0000, Liu, Chuansheng wrote:
> Hello Greg,
> 
> Double checked, there is no your response before.
> Can you consider it again? Thanks.

Consider what?  I get about 250 patches a _week_, I honestly do not
remember your specific patch, nor do I have it anywhere in front of me.

> Since we have printed the failure info, why not enhance it a bit:)
> 
> Example without this patch:
> pm_op(): platform_pm_suspend+0x0/0x50 returns -11
> PM: Device power.0 failed to suspend: error -11
> 
> And with this patch:
> platform_pm_suspend(): power_suspend+0x0/0x30 returns -11
> pm_op(): platform_pm_suspend+0x0/0x80 returns -11
> PM: Device power.0 failed to suspend: error -11

Ok, fine, get the PM maintainer to accept the patch then, resend it, cc:
the proper people and it will be considered.  If I hate it, I'll tell
you.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3CRQEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:04:00 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45326 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3CRQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:03:58 -0400
Date: Mon, 18 Mar 2013 09:05:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Fei <fei.li@intel.com>
Cc: rjw@sisk.pl, akpm@linux-foundation.org, ldewangan@nvidia.com,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Subject: Re: [PATCH] pm: print the name of failed suspend function for
 platform device
Message-ID: <20130318160514.GE3887@kroah.com>
References: <1363586303.9792.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363586303.9792.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 01:58:23PM +0800, Li Fei wrote:
> 
> Print more info when platform device suspend function failed.
> Without this patch, we can not get the real platform device suspend
> API info.
> 
> Example without this patch:
> pm_op(): platform_pm_suspend+0x0/0x50 returns -11
> PM: Device power.0 failed to suspend: error -11
> 
> And with this patch:
> platform_pm_suspend(): power_suspend+0x0/0x30 returns -11
> pm_op(): platform_pm_suspend+0x0/0x80 returns -11
> PM: Device power.0 failed to suspend: error -11

How does that help someone out?  One extra line?  What is that going to
allow a user to now do?

greg k-h

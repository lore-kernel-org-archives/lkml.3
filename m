Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3JNSK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:10:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3JNSKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:10:55 -0400
Date: Mon, 14 Oct 2013 11:10:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Xiao Jin <jin.xiao@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, sboyd@codeaurora.org, jslaby@suse.cz,
        oliver@neukum.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: put delayed_wb to list
Message-ID: <20131014181054.GA6023@kroah.com>
References: <1381223328.9531.3.camel@xiaojin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381223328.9531.3.camel@xiaojin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 05:08:48PM +0800, Xiao Jin wrote:
> 
> From: xiao jin <jin.xiao@intel.com>
> 
> If acm_write_start during acm suspend, write acm_wb is backuped
> to delayed_wb. When acm resume, the delayed_wb will be started.
> This mechanism can only record one write during acm suspend. More
> acm write will be abandoned.
> 
> This patch is to use list_head to record the write acm_wb during acm
> suspend. It can ensure no acm write abandoned.


This patch is line-wrapped, making it impossible to apply.  Please check
your email client and fix up to not do this in the future and resend
this patch.

thanks,

greg k-h

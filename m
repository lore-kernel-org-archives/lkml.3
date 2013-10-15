Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3JOAjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:39:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:25495 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab3JOAjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:39:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,495,1378882800"; 
   d="scan'208";a="410917518"
Subject: Re: [PATCH] USB: cdc-acm: put delayed_wb to list
From: Xiao Jin <jin.xiao@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, sboyd@codeaurora.org, jslaby@suse.cz,
        oliver@neukum.org, linux-usb@vger.kernel.org
In-Reply-To: <20131014181054.GA6023@kroah.com>
References: <1381223328.9531.3.camel@xiaojin>
	 <20131014181054.GA6023@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Oct 2013 08:50:09 +0800
Message-ID: <1381798209.2495.1.camel@xiaojin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg,

I am sorry for the inconvenience. I will the patch format with the title
v2. Thanks for the review.

On Mon, 2013-10-14 at 11:10 -0700, Greg KH wrote:
> On Tue, Oct 08, 2013 at 05:08:48PM +0800, Xiao Jin wrote:
> > 
> > From: xiao jin <jin.xiao@intel.com>
> > 
> > If acm_write_start during acm suspend, write acm_wb is backuped
> > to delayed_wb. When acm resume, the delayed_wb will be started.
> > This mechanism can only record one write during acm suspend. More
> > acm write will be abandoned.
> > 
> > This patch is to use list_head to record the write acm_wb during acm
> > suspend. It can ensure no acm write abandoned.
> 
> 
> This patch is line-wrapped, making it impossible to apply.  Please check
> your email client and fix up to not do this in the future and resend
> this patch.
> 
> thanks,
> 
> greg k-h



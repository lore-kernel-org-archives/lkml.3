Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3FCIja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:39:30 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58274 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3FCIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <1370247842.29283.243.camel@smile>
References: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370015432-17259-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAKohpomwHMP=0hxkv4rLRWty28h6F408wmPq6FU_vixL1X-krA@mail.gmail.com>
	<1370247842.29283.243.camel@smile>
Date: Mon, 3 Jun 2013 14:09:27 +0530
Message-ID: <CAKohpo=Crkk3e9xJ_AGa04N5ce4dD7DJ+2Ge6Oi_w=_UWKdGYQ@mail.gmail.com>
Subject: Re: [RFC PATCH v0 1/2] dma: move dw_dmac driver to an own directory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2013 13:54, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> Imagine the case when we choose platform driver to be compiled as a
> module. It means both variables set to m.
>
> During compilation we will have core part compiled-in, and platform part
> as a module.
>
> I don't think this is what we want.

Correct. So, both are acked without any more comments :)

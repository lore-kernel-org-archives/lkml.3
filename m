Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3HWQsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:48:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3HWQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:48:12 -0400
Date: Fri, 23 Aug 2013 09:48:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Leon Ma <xindong.ma@intel.com>
Cc: ccross@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] LMK: Optimize lowmem_shrink
Message-ID: <20130823164810.GA25863@kroah.com>
References: <1377049265.22148.7.camel@leonma-sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377049265.22148.7.camel@leonma-sh>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:41:05AM +0800, Leon Ma wrote:
> From: Leon Ma <xindong.ma@intel.com>
> Date: Mon, 19 Aug 2013 14:22:38 +0800
> Subject: [PATCH] LMK: Optimize lowmem_shrink.

Why is all of this in the patch body?

And what does "LMK:" stand for?

> By comparing with selected_oom_score_adj instead of min_score_adj,
> we may do less calculation.

What does this change?  Does it fix a problem?

thanks,

greg k-h

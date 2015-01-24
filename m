Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbbAXCJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 21:09:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbAXCJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 21:09:46 -0500
Date: Sat, 24 Jan 2015 10:09:42 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-kernel@vger.kernel.org, Dave Mielke <dave@mielke.cc>
Subject: Re: [PATCH] vt: provide notifications on selection changes
Message-ID: <20150124020942.GA3230@kroah.com>
References: <alpine.LFD.2.11.1501231636200.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501231636200.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:07:21PM -0500, Nicolas Pitre wrote:
> The vcs device's poll/fasync support relies on the vt notifier to signal
> changes to the screen content.  Notifier invocations were missing for
> changes that comes through the selection interface though.  Fix that.
> 
> Tested with BRLTTY 5.2.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> Cc: Dave Mielke <dave@mielke.cc>
> 
> ---
> 
> Greg: Would be highly convenient to have this patch applied to the 
> stable tree as well to help affected blind Linux users via distro 
> updates.  Yet it took a while before this issue was discovered. Your 
> call.

Ok, that sounds good, I'll queue this up for 3.20-rc1 and mark it for
stable so it will get backported.

thanks,

greg k-h

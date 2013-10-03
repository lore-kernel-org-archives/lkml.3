Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3JCP1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:27:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3JCP1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:27:17 -0400
Date: Thu, 3 Oct 2013 08:27:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Use of drivers/platform and matching include?
Message-ID: <20131003152715.GA15931@kroah.com>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 09:45:38AM -0500, Kumar Gala wrote:
> As we look at upstreaming more support for the Qualcomm MSM SoCs there
> are a number of drivers or library like routines that are unique to
> the MSM platform, we are thinking that putting them under:
> 
> drivers/platform/qcom/

What type of drivers are these?  Shouldn't they really go under the
specific driver type directory instead?

> would make sense.  In addition there are headers that might need to
> get shared with drivers in other locations so I wanted to see what the
> take was on introducing:
> 
> include/linux/platform/qcom/
> 
> An example driver would be the means we utilize to communicate memory
> regions between various HW blocks on the SoC.  So a video/media core
> driver might need access to a header/functions from the memory region
> driver.

Isn't there arch-specific include directories already that are good for
stuff like this?

thanks,

greg k-h

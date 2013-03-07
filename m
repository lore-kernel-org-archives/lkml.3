Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab3CGRYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:24:49 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44746 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022Ab3CGRYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:24:48 -0500
X-Sasl-enc: 5C+EE/Hr0ieJMFnkASAyzwTa4dOUcxCVNEL7fOb3Gza4 1362677087
Date: Fri, 8 Mar 2013 01:25:20 +0800
From: Greg KH <greg@kroah.com>
To: oskar.andero@sonymobile.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        radovan.lekanovic@sonymobile.com,
        Peter Enderborg <peter.enderborg@sonymobile.com>, arve@android.com,
        rientjes@google.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] lowmemorykiller: Use ktimer instead of jiffies
Message-ID: <20130307172520.GA484@kroah.com>
References: <1362652359-23779-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362652359-23779-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:32:39AM +0100, oskar.andero@sonymobile.com wrote:
> From: Peter Enderborg <peter.enderborg@sonymobile.com>
> 
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Peter Enderborg <peter.enderborg@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---

No changelog entry saying why you want this change?  You need to explain
this, otherwise I'll assume it's not needed at all, and just drop it...

thanks,

greg k-h

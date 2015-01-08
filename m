Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbbAHIOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:14:55 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:35207 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbbAHIOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:14:53 -0500
Date: Thu, 8 Jan 2015 09:14:46 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux390@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH RFT] s390: move cacheinfo sysfs to generic cacheinfo
 infrastructure
Message-ID: <20150108081446.GC3997@osiris>
References: <1420702912-9749-1-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420702912-9749-1-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010808-0041-0000-0000-000002C97CC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 07:41:52AM +0000, Sudeep Holla wrote:
> This patch removes the redundant sysfs cacheinfo code by reusing
> the newly introduced generic cacheinfo infrastructure through the
> commit 246246cbde5e ("drivers: base: support cpu cache information
> interface to userspace via sysfs")
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> ---
>  arch/s390/kernel/cache.c | 388 +++++++++++------------------------------------
>  1 file changed, 92 insertions(+), 296 deletions(-)
> 
> Hi Heiko,
> 
> If you can give this a quick testing though nothing has changes since
> you last tested it, that would be good.
> 
> If nothing is broken, please feel free to take this through your tree.
> 
> Regards,
> Sudeep

Still works. I forwarded your patch with my sign-off to Martin, so he can
apply it for the next merge window.

Thanks a lot for your work!
Heiko


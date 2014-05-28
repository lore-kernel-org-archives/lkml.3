Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaE1UsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:48:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaE1UsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:48:10 -0400
Date: Wed, 28 May 2014 13:51:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
Message-ID: <20140528205145.GB10468@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:26:32PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
> deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
> functions in favour of the unified smp_mb__{before,after}_atomic().
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/base/fence.c | 4 ++--

Where does this file come from?  I've not seen it before, and it's not
in my tree.

confused,

greg k-h

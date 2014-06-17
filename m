Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbaFQTTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:19:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbaFQTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:19:37 -0400
Date: Tue, 17 Jun 2014 12:23:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/24] powerpc: check/return actual error on sysfs
 functions
Message-ID: <20140617192334.GA4628@kroah.com>
References: <53A0512D.1090909@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A0512D.1090909@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:31:09PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  arch/powerpc/platforms/powernv/opal-dump.c | 2 +-
>  arch/powerpc/platforms/powernv/opal-elog.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Ben and Paul, please do not take this patch, it is incorrect.

greg k-h

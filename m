Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbaFQTUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:20:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbaFQTUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:20:32 -0400
Date: Tue, 17 Jun 2014 12:24:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/24]  drivers/iommu: check actual error on iommu_init
Message-ID: <20140617192430.GC4628@kroah.com>
References: <53A050BF.3000101@oracle.com>
 <20140617152154.GE31771@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617152154.GE31771@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 05:21:54PM +0200, Joerg Roedel wrote:
> On Tue, Jun 17, 2014 at 10:29:19PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > kset_create_and_add() has been fixed to return the actual error
> > code ptr rather than NULL, so update iommu_init() to check the
> > return value via IS_ERR() accordingly.
> > 
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Acked-by: Joerg Roedel <joro@8bytes.org>

Nope, please do not take this patch, it is not needed and as the kset
call is not changing, it will be incorrect.

thanks,

greg k-h

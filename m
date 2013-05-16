Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab3EPEAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:00:04 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44286 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3EPEAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:00:01 -0400
Date: Thu, 16 May 2013 00:00:09 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 0/6] Drivers: hv/scsi: Implement multi-channel support
Message-ID: <20130516040009.GA16728@kroah.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368655320-27599-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 03:02:00PM -0700, K. Y. Srinivasan wrote:
> This patch-set implements multi-channel support for Hyper-V devices. Also
> support for synthetic Fiber Channel device is included. The first two
> patches in the series are the foundational pieces for the remaining patches.
> 
> James, once Greg accepts the first two patches, you can consider the scsi
> patches.

I have no objection for these first two patches to go through James's
tree, I'll go add my ack to them.  That should make it easier for
everyone involved.

thanks,

greg k-h

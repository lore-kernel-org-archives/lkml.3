Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3EPEBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:01:41 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:36375 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3EPEBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:01:37 -0400
Date: Thu, 16 May 2013 00:01:45 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 2/6] Drivers: hv: Add the GUID fot synthetic fiber
 channel device
Message-ID: <20130516040145.GC16728@kroah.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368655354-27651-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 03:02:30PM -0700, K. Y. Srinivasan wrote:
> In preparation for supporting synthetic Fiber Channel device, add the GUID for
> this service.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  include/linux/hyperv.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

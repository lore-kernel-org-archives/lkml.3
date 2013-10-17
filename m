Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050Ab3JQB1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:27:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322Ab3JQB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:27:04 -0400
Date: Wed, 16 Oct 2013 18:27:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: bus: omap_l3: remove deprecated IRQF_DISABLED
Message-ID: <20131017012703.GA4704@kroah.com>
References: <1381552652-6449-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381552652-6449-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 06:37:32AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/bus/omap_l3_noc.c | 4 ++--
>  drivers/bus/omap_l3_smx.c | 6 ++----
>  2 files changed, 4 insertions(+), 6 deletions(-)

These files aren't "mine", I suggest sending this to the OF maintainers
that scripts/get_maintainer.pl points out for this patch.

thanks,

greg k-h

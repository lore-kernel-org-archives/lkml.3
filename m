Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaHQQuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:50:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaHQQuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:50:15 -0400
Date: Sun, 17 Aug 2014 09:49:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hans Wennborg <hans@hanshq.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192ee: fix %d confusingly prefixed with 0x
 in format strings
Message-ID: <20140817164938.GA28632@kroah.com>
References: <20140810042358.GA15249@kroah.com>
 <1407727722-28095-1-git-send-email-hans@hanshq.net>
 <1407727722-28095-2-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407727722-28095-2-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 08:28:42PM -0700, Hans Wennborg wrote:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/staging/rtl8192ee/pci.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This patch doesn't apply at all to my tree, can you please refresh it
against the next linux-next tree and resend?

thanks,

greg k-h

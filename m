Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaHJMLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:11:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaHJMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:22 -0400
Date: Sat, 9 Aug 2014 21:27:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Adrian Remonda <adrianremonda@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCHv2 2/2] Staging: rtl8188eu: Removed unnecessarry code.
Message-ID: <20140810042730.GA25108@kroah.com>
References: <1407447471-11632-1-git-send-email-adrianremonda@gmail.com>
 <1407447471-11632-2-git-send-email-adrianremonda@gmail.com>
 <20140808090538.GH4856@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808090538.GH4856@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 12:05:38PM +0300, Dan Carpenter wrote:
> On Thu, Aug 07, 2014 at 11:37:51PM +0200, Adrian Remonda wrote:
> > This patch clear some code that was not doing any help.
> > Pointed out by Larry.Finger
> > 
> 
> The patch is fine but the changelog doesn't inpsire confidence.  It
> should say:
> 
> This patch removes some unneeded code.
> 1) kzalloc() allocates 4 extra bytes so that we can align the return
>    value.  But actually the return value is already aligned so we can
>    remove the + 4 and the call to N_BYTE_ALIGMENT().
> 2) The memset() isn't needed because kzalloc() zeroes the allocation.
> 
> Suggested-by: Larry Finger <Larry.Finger@lwfinger.net>

Adrian, can you please fix this up and resend the series based on Dan's
comments?

thanks,

greg k-h

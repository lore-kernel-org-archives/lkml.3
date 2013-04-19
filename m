Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075Ab3DSXYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 19:24:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42855 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964912Ab3DSXYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 19:24:22 -0400
Date: Fri, 19 Apr 2013 16:24:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: kys@microsoft.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Message-ID: <20130419232419.GA8900@kroah.com>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 04:28:27PM +0100, Olaf Hering wrote:
> This change fixes a few compile errors:
> 
> hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> hv_vss_daemon.c: In function 'vss_operate':
> hv_vss_daemon.c:66: warning: 'return' with no value, in function returning non-void
> hv_vss_daemon.c: In function 'main':
> hv_vss_daemon.c:130: warning: ignoring return value of 'daemon', declared with attribute warn_unused_result
> hv_vss_daemon.c: In function 'vss_operate':
> hv_vss_daemon.c:47: warning: 'fs_op' may be used uninitialized in this function
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

For some reason, all of your hv tools patches ended up in my spam
filter.  KY, can you resend me any that I didn't apply, and you have
tested?

thanks,

greg k-h

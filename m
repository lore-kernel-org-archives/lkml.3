Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaFTAPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:15:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbaFTAPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:15:20 -0400
Date: Thu, 19 Jun 2014 17:19:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH linux-next] staging: r8192ee: Adapt flush function
 prototype
Message-ID: <20140620001921.GA22619@kroah.com>
References: <1402162759-17074-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402162759-17074-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 07:39:19PM +0200, Vincent Stehlé wrote:
> Commit 77be2c54c5bd 'mac80211: add vif to flush call' modifies the flush
> operation prototype. Update r8192ee function accordingly.
> 
> This fixes the following compilation warnings:
> 
>   drivers/staging/rtl8192ee/core.c: At top level:
>   drivers/staging/rtl8192ee/core.c:1599:2: warning: initialization from incompatible pointer type [enabled by default]
>     .flush = rtl_op_flush,
>     ^
>   drivers/staging/rtl8192ee/core.c:1599:2: warning: (near initialization for ‘rtl92e_ops.flush’) [enabled by default]
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Hi,
> 
> Linux next gives a "heads up" that the flush function of staging driver r8192ee
> needs to be adapted soon.
> 
> This can be seen with e.g. linux next-20140606 and x86 allmodconfig.
> 
> Also, r8192ee would benefit from the following patch:
> http://www.spinics.net/lists/linux-driver-devel/msg47690.html

This doesn't apply as I think it's already done part of a merge...

greg k-h

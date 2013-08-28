Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3H1Fuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:50:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3H1Fue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:50:34 -0400
Date: Tue, 27 Aug 2013 22:52:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] drivers/base/memory.c: introduce help macro
 to_memory_block
Message-ID: <20130828055253.GA22776@kroah.com>
References: <521B2ED2.2010501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521B2ED2.2010501@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 06:32:50PM +0800, Gu Zheng wrote:
> Introduce help macro to_memory_block to hide the conversion(device-->memory_block),
> just clean up.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  drivers/base/memory.c |   27 ++++++++++++---------------
>  1 files changed, 12 insertions(+), 15 deletions(-)

This patch doesn't apply to my driver-core-next branch, as some changes
have happened in this area recently.  Can you please refresh it and
resend it if it is still needed?

thanks,

greg k-h

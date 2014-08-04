Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaHDVmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:42:19 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56217 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaHDVmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:42:17 -0400
Message-ID: <53DFFE2A.7010002@gmail.com>
Date: Mon, 04 Aug 2014 14:42:02 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kiran Padwal <kiran.padwal@smartplayin.com>
CC: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        sboyd@codeaurora.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm: fix checkpatch warnings
References: <1407162046-29729-1-git-send-email-kiran.padwal@smartplayin.com>
In-Reply-To: <1407162046-29729-1-git-send-email-kiran.padwal@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/2014 7:20 AM, Kiran Padwal wrote:
> This patch fixes the following checkpatch.pl warning:
> 
> WARNING: braces {} are not necessary for any arm of this statement
> 
> WARNING: Missing a blank line after declarations
> 
> WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> 
> WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> WARNING: else is not generally useful after a break or return
> 
> WARNING: void function return statements are not generally useful
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/tty/serial/msm_serial.c |   26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)

Kiran,

I have a series of fix patches against this file that is going to collide
with your cleanups.  Would you mind waiting until after I send my patches
to do your clean up?

Thanks,

Frank


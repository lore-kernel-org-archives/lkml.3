Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaH3VBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:01:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaH3VB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:01:29 -0400
Date: Sat, 30 Aug 2014 14:01:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ramon Fried <ramon.fried@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: netlogic: fixed checkpatch.pl styling warnings
Message-ID: <20140830210128.GA11560@kroah.com>
References: <20140830195432.GA29429@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140830195432.GA29429@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 10:54:32PM +0300, Ramon Fried wrote:
> This patch fixes the following checkpatch.pl warnings:
> 
> WARNING: Possible unnecessary 'out of memory' message
> #146: FILE: ./xlr_net.c:146:
> +	if (!skb) {
> +		pr_err("SKB allocation failed\n");
> 
> WARNING: Missing a blank line after declarations
> #1107: FILE: ./xlr_net.c:1107:
> +	struct xlr_net_priv *priv = platform_get_drvdata(pdev);
> +	unregister_netdev(priv->ndev);

> >From 27b58d9b1d39ab99bf6022b82ac9e602621b2822 Mon Sep 17 00:00:00 2001
> From: Ramon Fried <ramon.fried@gmail.com>
> Date: Sat, 30 Aug 2014 22:26:11 +0300
> Subject: [PATCH] staging: netlogic: fixed checkpatch.pl styling warnings
> 
> Signed-off-by: Ramon Fried <ramon.fried@gmail.com>

WHy did you not put the information above in the changelog area here?

And why send a patch as an attachment, I can't do much of anything with
that :(

Also, please use the scripts/get_maintainer.pl tool to determine who and
what mailing lists to cc: for a patch.

Please fix this up and resend.

thanks,

greg k-h

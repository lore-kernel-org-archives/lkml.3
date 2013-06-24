Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3FXUeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:34:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3FXUeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:34:01 -0400
Date: Mon, 24 Jun 2013 13:33:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/32] drivers: delete __cpuinit usage from all remaining
 drivers files
Message-ID: <20130624203359.GA3126@kroah.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-32-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372102237-8757-32-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 03:30:36PM -0400, Paul Gortmaker wrote:
> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
> 
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
> 
> This removes all the remaining one-off uses of the __cpuinit macros
> from all C files in the drivers/* directory.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

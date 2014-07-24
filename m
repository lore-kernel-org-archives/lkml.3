Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbaGXBUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:20:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaGXBUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:20:50 -0400
Date: Wed, 23 Jul 2014 18:20:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Oczek <jeffoczek@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: cxt1e1: Prefix ambiguous variable names
 with 'cxt1e1_' for clarity
Message-ID: <20140724012050.GA32316@kroah.com>
References: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
 <1406075696-15912-1-git-send-email-jeffoczek@gmail.com>
 <1406075696-15912-2-git-send-email-jeffoczek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406075696-15912-2-git-send-email-jeffoczek@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 08:34:55PM -0400, Jeff Oczek wrote:
> Changed names of ambiguous sounding variable names as follows
> 
> error_flag          ->  cxt1e1_error_flag
> max_mtu_default     ->  cxt1e1_max_mtu_default
> max_txdesc_used     ->  cxt1e1_max_txdesc_used
> max_txdesc_default  ->  cxt1e1_max_txdesc_default
> max_rxdesc_used     ->  cxt1e1_max_rxdesc_used
> max_rxdesc_default  ->  cxt1e1_max_rxdesc_default
> 
> Since max_txdesc_used, max_rxdesc_used are module parameters, these were
> changed from global to static and the module init function assigns the values
> to the newly named global variables
> 
> Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
> ---
>  drivers/staging/cxt1e1/hwprobe.c   |  7 ++---
>  drivers/staging/cxt1e1/linux.c     | 53 +++++++++++++++++++++-----------------
>  drivers/staging/cxt1e1/musycc.c    |  4 +--
>  drivers/staging/cxt1e1/pmcc4_drv.c | 22 +++++++++-------
>  drivers/staging/cxt1e1/sbeproc.c   |  6 ++---
>  5 files changed, 51 insertions(+), 41 deletions(-)

This driver isn't even in my kernel tree anymore, so how can I apply it?

What kernel branch/version did you make it against?  Please always work
against linux-next, or my staging-next of my staging.git kernel tree
when sending patches.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaIHTfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:35:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58146 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbaIHTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:35:45 -0400
X-Sasl-enc: wS+w3NA1Z79cpEHyEZqr04KLtzt9yBT/DMHym0WhkTeF 1410204944
Date: Mon, 8 Sep 2014 12:35:43 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: lustre: Fix "space prohibited after
 that open parenthesis '('" errors
Message-ID: <20140908193543.GA13714@kroah.com>
References: <1409692460-9712-1-git-send-email-gdonald@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409692460-9712-1-git-send-email-gdonald@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 04:14:20PM -0500, Greg Donald wrote:
> Fix checkpatch.pl "space prohibited after that open parenthesis '('" errors
> 
> Signed-off-by: Greg Donald <gdonald@gmail.com>
> ---
>  drivers/staging/lustre/lustre/lmv/lmv_internal.h   |  2 +-
>  .../lustre/lustre/obdclass/linux/linux-module.c    |  4 ++--
>  drivers/staging/lustre/lustre/obdclass/obdo.c      | 28 +++++++++++-----------
>  3 files changed, 17 insertions(+), 17 deletions(-)

I've already applied part of this patch from someone else, can you
refresh and resend?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaJHW53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:57:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJHW50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:57:26 -0400
Date: Wed, 8 Oct 2014 15:57:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Cheng-wei Lee <lee.rhapsody@gmail.com>
Cc: johannes.berg@intel.com, josh@joshtriplett.org,
        sarah.a.sharp@linux.intel.com, himangi774@gmail.com,
        teobaluta@gmail.com, linville@tuxdriver.com, gamerh2o@gmail.com,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: wlan-ng: fix sparse warnings
Message-ID: <20141008225725.GA10158@kroah.com>
References: <542F5A5C.9050905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542F5A5C.9050905@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 10:24:28AM +0800, Cheng-wei Lee wrote:
> This patch fix the sparse warnings in wlan-ng/cfg80211.c
> The following functions were only used in this file, so done by
> declaring them into static.
> 
> drivers/staging/wlan-ng/cfg80211.c:710:6: warning: symbol
> 'prism2_connect_result' was not declared. Should it be static?
> drivers/staging/wlan-ng/cfg80211.c:719:6: warning: symbol
> 'prism2_disconnected' was not declared. Should it be static?
> drivers/staging/wlan-ng/cfg80211.c:725:6: warning: symbol
> 'prism2_roamed' was not declared. Should it be static?
> 
> Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
> ---
>  drivers/staging/wlan-ng/cfg80211.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This patch doesn't apply to my staging-testing branch of staging.git,
can you refresh it and resend please?

thanks,

greg k-h

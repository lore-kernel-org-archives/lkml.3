Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab3CZTJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:09:53 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35698 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3CZTJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:09:51 -0400
Date: Tue, 26 Mar 2013 20:09:40 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: kpark3469@gmail.com
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp_pch: eliminate a number of sparse warnings
Message-ID: <20130326190940.GC2494@netboy.at.omicron.at>
References: <1364267884-23518-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364267884-23518-1-git-send-email-kpark3469@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 12:18:04PM +0900, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@windriver.com>
> 
> This fixes a number of sparse warnings like:
>   warning: incorrect type in argument 2 (different address spaces)
>     expected void volatile [noderef] <asn:2>*addr
>     got unsigned int *<noident>
> 
>   warning: Using plain integer as NULL pointer
> 
> Additionally this fixes a warning from checkpatch.pl like:
>   WARNING: sizeof pch_param.station should be sizeof(pch_param.station)
> 
> Signed-off-by: Sahara <keun-o.park@windriver.com>

Looks okay to me. Please post this to the netdev list.

Thanks,
Richard

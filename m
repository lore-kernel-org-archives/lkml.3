Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbbAYQPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbbAYQPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:23 -0500
Date: Sun, 25 Jan 2015 19:37:46 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shirish Gajera <gajerashirish@gmail.com>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, domagoj.trsan@gmail.com,
        dan.carpenter@oracle.com, roxanagabriela10@gmail.com,
        dilekuzulmez@gmail.com, ben@decadent.org.uk, daeseok.youn@gmail.com,
        sulamiification@gmail.com, aysemelikeyurtoglu@gmail.com,
        rusty@rustcorp.com.au, tapaswenipathak@gmail.com,
        sasha.levin@oracle.com, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: Fix warning of line over 80 characters.
Message-ID: <20150125113746.GA17586@kroah.com>
References: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 11:57:53PM -0800, Shirish Gajera wrote:
> This patch fixes the checkpatch.pl warning:
> 
> WARNING: line over 80 characters
> 
> All line over 80 characters in driver/staging/speakup/* are fixed
> 
> Signed-off-by: Shirish Gajera <gajerashirish@gmail.com>
> ---
>  drivers/staging/speakup/main.c           | 12 ++++++++----
>  drivers/staging/speakup/serialio.h       |  3 ++-
>  drivers/staging/speakup/speakup.h        |  6 ++++--
>  drivers/staging/speakup/speakup_decext.c |  6 ++++--
>  drivers/staging/speakup/speakup_decpc.c  |  6 ++++--
>  drivers/staging/speakup/spk_priv.h       |  3 ++-
>  drivers/staging/speakup/spk_types.h      |  3 ++-
>  drivers/staging/speakup/synth.c          | 10 +++++-----
>  8 files changed, 31 insertions(+), 18 deletions(-)

This patch fails to apply to my staging-testing branch of my staging.git
tree, can you refresh it and resend, hopefully taking Dan's advice and
fixing up those two specific issues he pointed out.

thanks,

greg k-h

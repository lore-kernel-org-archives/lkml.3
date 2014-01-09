Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbaAISns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:43:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbaAISnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:39 -0500
Date: Thu, 9 Jan 2014 10:44:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Morgan Creekmore <gamingrobot@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rts5139: Fixed style issues
Message-ID: <20140109184410.GD10563@kroah.com>
References: <1389017109-16032-1-git-send-email-gamingrobot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389017109-16032-1-git-send-email-gamingrobot@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 07:05:09AM -0700, Morgan Creekmore wrote:
> Fixed style issues for lines over 80 chars
> 
> Signed-off-by: Morgan Creekmore <gamingrobot@gmail.com>
> ---
>  drivers/staging/rts5139/rts51x_card.c | 10 +++++-----
>  drivers/staging/rts5139/rts51x_card.h |  8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/rts5139/rts51x_card.c b/drivers/staging/rts5139/rts51x_card.c
> index 509d83e..03456d9 100644
> --- a/drivers/staging/rts5139/rts51x_card.c
> +++ b/drivers/staging/rts5139/rts51x_card.c
> @@ -373,7 +373,7 @@ void rts51x_release_cards(struct rts51x_chip *chip)
>  
>  static inline u8 double_depth(u8 depth)
>  {
> -	return ((depth > 1) ? (depth - 1) : depth);
> +	return (depth > 1) ? (depth - 1) : depth;

This fix isn't what you said you were doing in the above changelog
description :(

Please be correct in your changelogs.

greg k-h

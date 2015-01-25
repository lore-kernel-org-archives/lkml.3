Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbbAYQPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbbAYQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:34 -0500
Date: Sun, 25 Jan 2015 19:47:45 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Milkovich <amilkovich@gmail.com>
Cc: benjamin.romer@unisys.com, david.kershner@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Message-ID: <20150125114745.GA4928@kroah.com>
References: <1421550678-9920-1-git-send-email-amilkovich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421550678-9920-1-git-send-email-amilkovich@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 07:11:18PM -0800, Andrew Milkovich wrote:
> Fixed coding style errors per checkpatch.pl. Inline comments removed; chanptr
> comment is implied by the first argument being the channel. No parent bus
> comment is already understood by the argument being NULL.
> 
> Signed-off-by: Andrew Milkovich <amilkovich@gmail.com>
> ---
>  drivers/staging/unisys/virtpci/virtpci.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)

This patch doesn't apply at all to the staging-next branch of
staging.git, so I can't apply it :(

thanks,

greg k-h

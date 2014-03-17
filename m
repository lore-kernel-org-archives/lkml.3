Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaCQU65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:58:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaCQU64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:58:56 -0400
Date: Mon, 17 Mar 2014 14:00:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conrad Meyer <cemeyer@uw.edu>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Meyer <cse.cem@gmail.com>
Subject: Re: [PATCH] Staging: comedi: fixup: dev_warn() with correct dev
Message-ID: <20140317210056.GA24072@kroah.com>
References: <531F1B76.6010608@mev.co.uk>
 <1394549897-15186-1-git-send-email-cse.cem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394549897-15186-1-git-send-email-cse.cem@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 07:58:17AM -0700, Conrad Meyer wrote:
> Replace hw_dev with class_dev in new dev_warn()s.
> 
> 
> Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 104 ++++++++++-----------
>  1 file changed, 52 insertions(+), 52 deletions(-)

This doesn't apply at all, can you redo it against my latest tree and
resend?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3A3IIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:08:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:44441 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3A3IIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:08:44 -0500
Date: Tue, 29 Jan 2013 23:29:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 10/11] staging/fwserial: Fix premature unthrottle
Message-ID: <20130130042947.GA25371@kroah.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
 <1359430485-5301-10-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359430485-5301-10-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:34:44PM -0500, Peter Hurley wrote:
> The unthrottle may restart the writer before the rx push
> has a chance to start emptying the rx buffer, resulting in an
> overflowed rx buffer and lost data.
> 
> Perform the actual device unthrottle with the rx push instead.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/staging/fwserial/fwserial.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)

this patch fails to apply to my tree, but the 9 previous ones were fine,
so I'll not apply it, or ght 11/11 patch.  Care to fix it up and resend
both of them?

thanks,

greg k-h

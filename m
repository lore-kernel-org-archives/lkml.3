Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbaJ2PmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:42:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203AbaJ2PmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:19 -0400
Date: Wed, 29 Oct 2014 17:44:49 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH RESEND v2 1/2] Staging: rts5208: helper function to
 manage aspm during reset
Message-ID: <20141029094449.GA12840@kroah.com>
References: <1414522016-3961-1-git-send-email-fabio.falzoi84@gmail.com>
 <1414522016-3961-2-git-send-email-fabio.falzoi84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414522016-3961-2-git-send-email-fabio.falzoi84@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 07:46:55PM +0100, Fabio Falzoi wrote:
> Define the helper function rtsx_reset_aspm to shorten the
> rtsx_reset_chip code and get rid of the LONG_LINE checkpatch warnings.
> 
> Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
> Reviewed-by: Dan Carpenter <dan.carpente@oracle.com>
> ---
>  drivers/staging/rts5208/rtsx_chip.c | 70 +++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 31 deletions(-)

These both don't apply, can you refresh again?

thanks,

greg k-h

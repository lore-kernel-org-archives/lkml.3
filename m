Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaAMSqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:46:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaAMSp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:45:57 -0500
Date: Mon, 13 Jan 2014 10:46:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DAS6402: Fixing foo * bar should be foo *bar
Message-ID: <20140113184633.GA11751@kroah.com>
References: <1389451728-3575-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389451728-3575-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 02:48:48PM +0000, Joe Borg wrote:
> ---
>  drivers/staging/comedi/drivers/das6402.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please always run your patches through the checkpatch.pl script, so that
we don't have to tell you the results of it as to why we can't accept
your patch :(

Care to try again for both of these?

greg k-h

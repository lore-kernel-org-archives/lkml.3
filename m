Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbbADXlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 18:41:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbbADXly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 18:41:54 -0500
Date: Sun, 4 Jan 2015 15:41:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, pankaj.saraf@nektech.in,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: comedi: fix line over 80 characters warning
Message-ID: <20150104234152.GA14138@kroah.com>
References: <1420289195-5012-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420289195-5012-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 06:16:31PM +0530, jitendra kumar khasdev wrote:
> This is patch to file pcl812.c that fix up warning line
> over 80 character which is found by checkpatch tool.
> 
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl812.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

There are 5 patches here all with the identical subject line, which I
can't accept for the obvious reason that they must be all doing the same
exact thing, which would be pointless, right?  :)

thanks,

greg k-h

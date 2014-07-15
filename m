Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaGON5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:57:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaGON5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:57:03 -0400
Date: Tue, 15 Jul 2014 06:56:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: sam-the-6 <asadi.samuel@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, chase.southwood@yahoo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 94/94] Staging: comedi: 3 files revised fixed style issues
Message-ID: <20140715135641.GC18292@kroah.com>
References: <1405430362-7359-1-git-send-email-asadi.samuel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405430362-7359-1-git-send-email-asadi.samuel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:19:22PM +0300, sam-the-6 wrote:
> From: Sam Asadi <asadi.samuel@gmail.com>
> 
> 3 files in 'staging/comedi/drivers/' revised again
> and style issues fixed
> 
> Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
> 
> 	modified:   drivers/staging/comedi/drivers/8253.h
> 	modified:   drivers/staging/comedi/drivers/8255.c
> 	modified:   drivers/staging/comedi/drivers/adl_pci9118.c
> ---
>  drivers/staging/comedi/drivers/8253.h        |   34 +++---
>  drivers/staging/comedi/drivers/8255.c        |  154 +++++++++++++-------------
>  drivers/staging/comedi/drivers/adl_pci9118.c |  140 +++++++++++------------
>  3 files changed, 167 insertions(+), 161 deletions(-)

As said before, this isn't an ok way to do this, please break it up into
individual changes per patch.

thanks,

greg k-h

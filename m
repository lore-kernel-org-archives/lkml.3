Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3GLOsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:48:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab3GLOsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:48:02 -0400
Date: Fri, 12 Jul 2013 07:48:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging-next] zram: protect zram_reset_device() call
Message-ID: <20130712144858.GA9979@kroah.com>
References: <20130626122839.GA2268@swordfish.minsk.epam.com>
 <51D3F0BE.8060109@redhat.com>
 <20130712134629.GA4007@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712134629.GA4007@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 04:46:29PM +0300, Sergey Senozhatsky wrote:
> On (07/03/13 11:37), Jerome Marchand wrote:
> > Subject: Re: [PATCH staging-next] zram: protect zram_reset_device() call
> > User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110
> >  Thunderbird/17.0.2
> > 
> > On 06/26/2013 02:28 PM, Sergey Senozhatsky wrote:
> > > Commit 9b3bb7abcdf2df0f1b2657e6cbc9d06bc2b3b36f (remove
> > > zram_sysfs file (v2)) accidentally made zram_reset_device()
> > > racy. Protect zram_reset_device() call with zram->lock.
> > > 
> > > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > Acked-by: Jerome Marchand <jmarchand@redhat.com>
> 
> Hello Greg,
> could you please apply this patch?

After the merge window is closed I will get to it, thanks.

greg k-h

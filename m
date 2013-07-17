Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab3GQSJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:09:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3GQSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:09:49 -0400
Date: Wed, 17 Jul 2013 11:09:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: [PATCH 05/21] iio: input: am335x_adc: Add continuous mode to adc
Message-ID: <20130717180954.GA19999@kroah.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374082010-28095-6-git-send-email-zubair.lutfullah@gmail.com>
 <20130717173801.GD17882@kroah.com>
 <CAExKytyQ23VXMVyRX9OHEQ8HZT5tFhKHSjhaH_-G_O1BVL91-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAExKytyQ23VXMVyRX9OHEQ8HZT5tFhKHSjhaH_-G_O1BVL91-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Wed, Jul 17, 2013 at 06:53:53PM +0100, Zubair Lutfullah wrote:
> checkpatch is applied at the end all together. The last 3 patches are those.
> 
> I guess that is non-standard practice.

Yes, each patch needs to be correct and complete, on its own.

> I'll have to redo the whole thing and take care about the From original author
> too.

That's really a very important thing to never loose, we don't want to
ever drop the correct authorship of a patch.

thanks,

greg k-h

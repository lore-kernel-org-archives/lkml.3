Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJLO0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:26:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJLOZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:25:58 -0400
Date: Sun, 12 Oct 2014 16:24:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141012142455.GC21479@kroah.com>
References: <20141010072439.GA1741@katana>
 <20141010083627.GL5182@n2100.arm.linux.org.uk>
 <20141010182604.GC6075@katana>
 <2769473.KEN6DZKnT7@wuerfel>
 <20141011165650.GA1263@katana>
 <20141011205527.GA30877@kroah.com>
 <20141012055146.GA1310@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012055146.GA1310@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 07:51:46AM +0200, Wolfram Sang wrote:
> 
> > I missed the one code path you pointed out, and that should be fixed,
> > but that doesn't mean that the original patch should be reverted, as it
> > is the way we want things to be, let's just fix up the bug and move on.
> 
> OK, that is a clear statement.
> 
> So, what is your opinion on the original cleanup series removing
> unnecessary '.owner = THIS_MODULE' lines in drivers? Helpful? Noise?

Helpful, please do it.  I can take it all through my driver-core tree if
you want, that might make things easier for others.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab3CQOET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:04:19 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50845 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab3CQOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:04:17 -0400
Date: Sun, 17 Mar 2013 07:05:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dongsheng Song <dongsheng.song@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.8.3
Message-ID: <20130317140528.GA2494@kroah.com>
References: <20130314184702.GA17860@kroah.com>
 <CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 10:00:08PM +0800, Dongsheng Song wrote:
> On Fri, Mar 15, 2013 at 2:47 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > I'm announcing the release of the 3.8.3 kernel.
> >
> > All users of the 3.8 kernel series must upgrade.
> >
> > The updated 3.8.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.8.y
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> >
> > thanks,
> >
> > greg k-h
> 
> Hi,
> 
> “make ARCH=arm menuconfig”  no complains,  but "make ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf-" failed:

Is this new (i.e. does 3.8.2 work?)

If so, what commit caused it?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3EHRuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:50:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab3EHRuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:50:22 -0400
Date: Wed, 8 May 2013 10:50:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9.1
Message-ID: <20130508175020.GA17950@kroah.com>
References: <20130508041010.GA17374@kroah.com>
 <20130508072245.GB4169@fysh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508072245.GB4169@fysh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 08:22:45AM +0100, Athanasius wrote:
> On Tue, May 07, 2013 at 09:10:10PM -0700, Greg KH wrote:
> > I'm announcing the release of the 3.9.1 kernel.
> > 
> > All users of the 3.9 kernel series must upgrade.
> > 
> > The updated 3.9.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> 
>   Usually I can:
> 
> 	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master

If you do that, you only get the master branch updated locally.  Which
tracks Linus's tree, not the different stable releases.

> which means not having to update scripts/commandline history on each
> major verison change, but this time I did indeed need to:
> 
> 	git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> 
> is this an intended change, or did you do something like forgetting to
> merge into master on linux-stable ?

No, I have not changed anything on my end, perhaps you never really were
updating the different stable branches?

thanks,

greg k-h

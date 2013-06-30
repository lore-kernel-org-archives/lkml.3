Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3F3AdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 20:33:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3F3AdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 20:33:02 -0400
Date: Sat, 29 Jun 2013 17:33:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.9.8
Message-ID: <20130630003348.GA23378@kroah.com>
References: <20130627175936.GA8732@kroah.com>
 <CA+QCeVTdiGNz05_L0MWVnY6W88tgt_gy4Duk5MoUR7Xi6KpRsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+QCeVTdiGNz05_L0MWVnY6W88tgt_gy4Duk5MoUR7Xi6KpRsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 11:58:04PM +0300, Sergey Meirovich wrote:
> Hi,
> 
> On 27 June 2013 20:59, Greg KH <gregkh@linuxfoundation.org> wrote:
> > I'm announcing the release of the 3.9.8 kernel.
> >
> > All users of the 3.9 kernel series must upgrade.
> 
> I've got issues with my radeon ("01:00.0 VGA compatible controller:
> Advanced Micro Devices, Inc. [AMD/ATI] Thames [Radeon HD 7500M/7600M
> Series]") APU on 3.9.8

But 3.9.7 worked?  Can you run 'git bisect' to track down the offending
commit?  Does 3.10-rc7 also have this problem?

thanks,

greg k-h

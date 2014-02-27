Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaB0TK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:10:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaB0TK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:10:27 -0500
Date: Thu, 27 Feb 2014 11:12:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC][PATCH] staging: Fix build issues with new binder API
Message-ID: <20140227191204.GA4967@kroah.com>
References: <1393453747-12513-1-git-send-email-john.stultz@linaro.org>
 <20140227033400.GA31199@kroah.com>
 <530F8C21.9070602@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F8C21.9070602@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:04:01AM -0800, John Stultz wrote:
> On 02/26/2014 07:34 PM, Greg KH wrote:
> > On Wed, Feb 26, 2014 at 02:29:07PM -0800, John Stultz wrote:
> >> The new 64bit binder API causes build issues on 32bit ARM
> >> due to the lack of 64bit __get_user_asm_* implementation.
> > So no one ever tested this out on ARM?  Really, that seems odd...
> 
> Its my bad, I was focused on the 32bit legacy compatibility code in my
> testing because the userspace I have only works with that.
> 
> Arve actually warned about this in one of his mails, but I mistakenly
> thought it was an issue w/ 3.10 and earlier kernels and had since been
> addressed.
> 
> 
> > Anyway, if you want this to always be on, that's fine with me, your
> > choice :)
> 
> I think its the best option for now, but wanted to send it out for
> comment to see if anyone objected.
> 
> I'm about to head for a conference so I'll be offline until around
> Monday. While at the conference I'm going to be working with folks to
> see if we can't get the real solution (a __get_user_asm_64
> implementation) sorted.  But if there are no objections, it might be
> best to queue this for staging-next so folks don't hit the issue in the
> meantime.

Yes, the "real" solution would be best, but I'll queue this up for now,
thanks.

greg k-h

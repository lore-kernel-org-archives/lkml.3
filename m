Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3GBEo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:44:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3GBEo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:44:26 -0400
Date: Mon, 1 Jul 2013 21:45:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Galeck <mark_galeck@pacbell.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: is it desirable to improve the build system?
Message-ID: <20130702044516.GA31484@kroah.com>
References: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 05:12:01PM -0700, Mark Galeck wrote:
> Dear Linux-Kernel Community,
> 
> I am a consultant specializing in builds, and I recently worked for a
> large client company, a world-wide leader in its field, where I
> overhauled their build system: sped it up by more of an order of
> magnitude, and improved maintainability, for example making
> comment-to-code ratio approach 1:1. 
> 
> A part of their build is a modified Linux kernel. I rebuilt it
> countless times in various configurations, but made only a few further
> changes, because those improvements would have a small effect on the
> whole system, and because they want to stay close to your current
> release for ease of porting.
> 
> From that limited experience, it nevertheless seemed to me, that the
> Linux kernel build, while correct, is somewhat slow, and the sources
> could be more readable.

How is it "slow"?  And it has to be correct, fast and non-correct
doesn't work well, does it :)

What "sources" are you referring to as being not readable?

> Does the Linux-Kernel Community perceive that is the case?
> 
> If so, do you think it is possible to improve?
> 
> If so, would such an attempt be welcome, including and especially by,
> the current maintainer(s) of the build?  Of course it would have to be
> completely backwards-compatible, including to the text output
> interface and requirements for modules makefiles.

Patches are always gladly accepted, if they work well, please feel free
to submit them.

> I do apologize if my impressions are simply the result of
> unfamilliarity and naivete, and that I don't understand the deep
> reasons why "it has to be this way", and that I am unaware that such
> attempts were already made by some very skilled people.  

What do you not understand that you think could be changed?

Have you looked at the history of the build code to help understand why
things were changed to be they way they are?  git should help you out
here.

thanks,

greg k-h

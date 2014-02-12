Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaBLQ0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:26:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaBLQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:26:12 -0500
Date: Wed, 12 Feb 2014 08:27:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/120] 3.13.3-stable review
Message-ID: <20140212162728.GB21336@kroah.com>
References: <20140211184823.492407127@linuxfoundation.org>
 <20140212042906.GD26490@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212042906.GD26490@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 08:29:06PM -0800, Guenter Roeck wrote:
> On Tue, Feb 11, 2014 at 11:04:01AM -0800, Greg Kroah-Hartman wrote:
> > Some -stable releases spring out from my build system bright and shiny
> > and ready to go.  Not so with these releases.  Maybe it's the horrid
> > weather that was happening during the creation of these kernels, or
> > something else, but whatever it was, they came into this world
> > screaming, kicking, killing build servers left-and-right, and breaking
> > the build every other patch.  Some developers decided to get into the
> > act, constantly pushing the boundaries of what is an acceptable -stable
> > patch, and trying to skirt the rules of upstream patches first numerous
> > times, making me even grumpier than normal, "forcing" me to relax and
> > take in an afternoon playing of the Lego movie...
> > 
> Come on, compared to me you are never grumpy.
> 
> > Test these out well, they have barely survived my systems, and I don't
> > trust them in the slightest to not eat your disks, reap your tasks, and
> > run away laughing as your CPU turns into a space heater.
> > 
> > You have been warned.
> > 
> Hmm ... not sure if I want to take that risk :-). Going to be fun.
> And looking for volunteers to provide me with a really great test suite
> which I can run in qemu (and which doesn't take me days to set up).

What about the new rcu test suite that has been added to the kernel
tree?

> > -----------------
> > 
> > This is the start of the stable review cycle for the 3.13.3 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu Feb 13 18:47:55 UTC 2014.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 126 pass: 122 skipped: 4 fail: 0
> 
> qemu tests all passed.
> 
> Results are as expected (even though that may be unexpected in this case ;-).

Yeah, it lives!   Thanks for testing all of these and letting me know.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaBLE3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:29:11 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50275 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBLE3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:29:09 -0500
Date: Tue, 11 Feb 2014 20:29:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/120] 3.13.3-stable review
Message-ID: <20140212042906.GD26490@roeck-us.net>
References: <20140211184823.492407127@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 11:04:01AM -0800, Greg Kroah-Hartman wrote:
> Some -stable releases spring out from my build system bright and shiny
> and ready to go.  Not so with these releases.  Maybe it's the horrid
> weather that was happening during the creation of these kernels, or
> something else, but whatever it was, they came into this world
> screaming, kicking, killing build servers left-and-right, and breaking
> the build every other patch.  Some developers decided to get into the
> act, constantly pushing the boundaries of what is an acceptable -stable
> patch, and trying to skirt the rules of upstream patches first numerous
> times, making me even grumpier than normal, "forcing" me to relax and
> take in an afternoon playing of the Lego movie...
> 
Come on, compared to me you are never grumpy.

> Test these out well, they have barely survived my systems, and I don't
> trust them in the slightest to not eat your disks, reap your tasks, and
> run away laughing as your CPU turns into a space heater.
> 
> You have been warned.
> 
Hmm ... not sure if I want to take that risk :-). Going to be fun.
And looking for volunteers to provide me with a really great test suite
which I can run in qemu (and which doesn't take me days to set up).

> -----------------
> 
> This is the start of the stable review cycle for the 3.13.3 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Feb 13 18:47:55 UTC 2014.
> Anything received after that time might be too late.
> 

Build results:
	total: 126 pass: 122 skipped: 4 fail: 0

qemu tests all passed.

Results are as expected (even though that may be unexpected in this case ;-).

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

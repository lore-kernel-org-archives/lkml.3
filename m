Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaBLTPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:15:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaBLTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:15:32 -0500
Date: Wed, 12 Feb 2014 11:16:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.13 000/120] 3.13.3-stable review
Message-ID: <20140212191649.GC1631@kroah.com>
References: <20140211184823.492407127@linuxfoundation.org>
 <52FBC226.8030607@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FBC226.8030607@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:49:10AM -0700, Shuah Khan wrote:
> On 02/11/2014 12:04 PM, Greg Kroah-Hartman wrote:
> >Some -stable releases spring out from my build system bright and shiny
> >and ready to go.  Not so with these releases.  Maybe it's the horrid
> >weather that was happening during the creation of these kernels, or
> >something else, but whatever it was, they came into this world
> >screaming, kicking, killing build servers left-and-right, and breaking
> >the build every other patch.  Some developers decided to get into the
> >act, constantly pushing the boundaries of what is an acceptable -stable
> >patch, and trying to skirt the rules of upstream patches first numerous
> >times, making me even grumpier than normal, "forcing" me to relax and
> >take in an afternoon playing of the Lego movie...
> >
> >Test these out well, they have barely survived my systems, and I don't
> >trust them in the slightest to not eat your disks, reap your tasks, and
> >run away laughing as your CPU turns into a space heater.
> >
> >You have been warned.
> >
> >-----------------
> >
> 
> Worked fine on all my test systems. Compile tests and boot tests passed. No
> dmesg regressions: emerg, crit, alert, err are clean. No regressions in
> warn.

Great, thanks for testing all 4 of these, I feel better about them now.

greg k-h

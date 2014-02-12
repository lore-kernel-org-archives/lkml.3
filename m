Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaBLQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:25:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaBLQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:25:27 -0500
Date: Wed, 12 Feb 2014 08:26:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 000/120] 3.13.3-stable review
Message-ID: <20140212162643.GA21336@kroah.com>
References: <20140211184823.492407127@linuxfoundation.org>
 <20140212083223.GD13873@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212083223.GD13873@1wt.eu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 09:32:23AM +0100, Willy Tarreau wrote:
> Hi Greg,
> 
> On Tue, Feb 11, 2014 at 11:04:01AM -0800, Greg Kroah-Hartman wrote:
> > Test these out well, they have barely survived my systems, and I don't
> > trust them in the slightest to not eat your disks, reap your tasks, and
> > run away laughing as your CPU turns into a space heater.
> > 
> > You have been warned.
> 
> I upgraded my netbook from 3.10.x to test it (asus 1025C). It seems
> to work, cpufreq, SATA, FB, Xorg (gma500), wifi (ath9k), LAN (atl1c),
> sound, suspend. I'm hearing the fan run all the time without the CPU
> spinning, but I suspect that it's the result of upgrading from 3.10
> to 3.13, I'll have to dig that later (I didn't find anything related
> to this in .3-rc1). I know this is very limited for a test, but it's
> all I can provide for now.

Can you verify if 3.13.0 also has this problem for you or not?

thanks,

greg k-h

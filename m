Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaGTW2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 18:28:21 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:55735 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbaGTW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 18:28:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYKAIpBzFN5LHOdPGdsb2JhbABZgw6DUIUIpnsBAQEBAgaeNgGBBxcEAQEBATg2hAQBBTocIxAIAxgJJQ8FJQMHGhOIQcAgFxiFY4lQB4RGAQSbJJgGKy8
Date: Mon, 21 Jul 2014 08:28:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Linda A. Walsh" <lkml@tlinx.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Howto tell kernel to use 4096 as granularity & minimum size?
Message-ID: <20140720222818.GM4453@dastard>
References: <53CC0EAA.2010202@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CC0EAA.2010202@tlinx.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 11:47:06AM -0700, Linda A. Walsh wrote:
> I have a hard disk with a "512e" sector size: emulated 512, really 4096.
> 
> The disk returns a 512-byte size to drivers for compatibility.
> 
> I can partition the disk and setup the allocation size
> to 4096, but I'd like to tell the kernel to use a
> virtual-size of 4096 for the sector as an additional
> performance 'hint', so nothing will even try to use
> smaller i/o's than that.

Just format the filesystem with 4k sector size.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

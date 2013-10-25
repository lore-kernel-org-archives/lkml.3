Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JYVBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:01:40 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48914 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab3JYVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:01:38 -0400
Date: Fri, 25 Oct 2013 14:01:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: Tree for Oct 25
Message-ID: <20131025210130.GA31451@roeck-us.net>
References: <1382713426-2680-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382713426-2680-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 05:03:45PM +0200, Thierry Reding wrote:
> Hi all,
> 
> I've uploaded today's linux-next tree to the master branch of the
> repository below:
> 
>         git://gitorious.org/thierryreding/linux-next.git
> 
> A next-20131025 tag is also provided for convenience.
> 
> One new trivial conflicts and a new build failure caused by an incorrect
> use of the genpool allocator.
> 
> Upon a request from Olof Johansson I've only included fixes for build
> breakage as a result of interactions between the various trees. But
> since I've fixed many of the other build failures already, I've pushed
> those to a separate tag (next-20131025-fixes). That builds fine on x86
> 32-bit and 64-bit allmodconfigs as well as ARM and x86 default
> configurations. Most of the PowerPC build errors have also been fixed.
> 
Hi Thierry,

You are making a good point for your previous approach, but maybe it is
necessary to show people the real status of the -next tree.

	total: 110 pass: 4 skipped: 4 fail: 102

All ten qemu tests fail as well, though I didn't check if all are build failures
or if there are some runtime failures.

This is with " v3.12-rc5-8053-g9e11bce".

Guenter

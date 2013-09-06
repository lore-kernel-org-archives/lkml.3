Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3IFU0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:26:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50031 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3IFU0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:26:48 -0400
Message-ID: <522A3A7A.8030408@kernel.dk>
Date: Fri, 06 Sep 2013 14:26:34 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.12 for Jens Axboe
References: <20130906202551.GA20743@phenom.dumpdata.com>
In-Reply-To: <20130906202551.GA20743@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 02:25 PM, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> I sent you a git pull a couple of weeks ago but I am not sure if
> you pulled it. It does not look like it, so here it is again along
> with an extra bug-fix.
> 
> Please git pull:
> 
>  git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.12
> 
> which will give you bug-fixes to Xen blkfront and backend driver:

Thanks, I'll get the 3.12 branch set up and pulled in. I'm behind on a
lot of other drivers, too.

-- 
Jens Axboe


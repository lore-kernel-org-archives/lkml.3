Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3KDRkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:40:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37477 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3KDRkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:40:22 -0500
Message-ID: <5277DBF2.8030209@kernel.dk>
Date: Mon, 04 Nov 2013 10:40:02 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.12 for Jens Axboe
References: <20130906202551.GA20743@phenom.dumpdata.com> <522A3A7A.8030408@kernel.dk> <20131104173711.GA7116@phenom.dumpdata.com>
In-Reply-To: <20131104173711.GA7116@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 10:37 AM, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 06, 2013 at 02:26:34PM -0600, Jens Axboe wrote:
>> On 09/06/2013 02:25 PM, Konrad Rzeszutek Wilk wrote:
>>> Hey Jens,
>>>
>>> I sent you a git pull a couple of weeks ago but I am not sure if
>>> you pulled it. It does not look like it, so here it is again along
>>> with an extra bug-fix.
>>>
>>> Please git pull:
>>>
>>>  git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.12
>>>
>>> which will give you bug-fixes to Xen blkfront and backend driver:
>>
>> Thanks, I'll get the 3.12 branch set up and pulled in. I'm behind on a
>> lot of other drivers, too.
> 
> Hm, looks like you never pulled that for v3.12.

It is in:

axboe@axboe ~/git/linux-block $ git pull
git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git
stable/for-jens-3.12
>From git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
 * branch            stable/for-jens-3.12 -> FETCH_HEAD
Merge made by the 'recursive' strategy.
axboe@axboe ~/git/linux-block $

> There is one more patch that Roger has provided. Do you want to pull
> this branch for v3.13 nowish or wait until I put in Roger's patch?

You'll need to queue that up or send as a patch separately.--
Jens Axboe


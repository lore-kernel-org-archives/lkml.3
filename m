Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3KESPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:15:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36666 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3KESPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:15:05 -0500
Message-ID: <52793594.1000201@kernel.dk>
Date: Tue, 05 Nov 2013 11:14:44 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.13
References: <20131105165908.GA405@phenom.dumpdata.com> <52792410.5020200@kernel.dk> <20131105171723.GA506@phenom.dumpdata.com>
In-Reply-To: <20131105171723.GA506@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 10:17 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 05, 2013 at 10:00:00AM -0700, Jens Axboe wrote:
>> On 11/05/2013 09:59 AM, Konrad Rzeszutek Wilk wrote:
>>>
>>> Hey Jens,
>>>
>>> Please git pull the following branch:
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.13
>>>
>>>
>>> which has a fix to the Xen block frontend driver. For the backends that
>>> don't support persistent grants, we don't want to use the logic that would
>>> use copying (needed for persistent grants). That logic existed there initially
>>> but with the persistent grants code added in - it was removed (so in 3.10
>>> time-frame). This adds part of it back.
>>>
>>> Please pull!
>>
>> Did you forget to publish it?
> 
> No, but I gave you the wrong git tree <sad>
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.13
> 
> Sorry about that.

That did work a lot better. Thanks, pulled.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaLJOV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:21:26 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:65095 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaLJOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:21:25 -0500
Message-ID: <548856D7.2070706@mvista.com>
Date: Wed, 10 Dec 2014 08:21:11 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Rex <tony.rex@ericsson.com>,
        Magnus Johansson E <magnus.e.johansson@ericsson.com>,
        =?UTF-8?B?UGVyIEZvZ2Vsc3Ryw7Zt?= <per.fogelstrom@ericsson.com>,
        Jeremy Kerr <jk@ozlabs.org>, Sanjeev <singhsan@codeaurora.org>,
        Thomas Renninger <trenn@suse.de>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [GIT PULL] ipmi driver updates
References: <54873864.3050606@mvista.com> <1418208784.9279.11.camel@ellerman.id.au>
In-Reply-To: <1418208784.9279.11.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 04:53 AM, Michael Ellerman wrote:
> Hi Corey,
>
> On Tue, 2014-12-09 at 11:59 -0600, Corey Minyard wrote:
>> Jeremy Kerr (2):
>>       powerpc/powernv: Add OPAL IPMI interface
>>       drivers/char/ipmi: Add powernv IPMI driver
> I created a topic branch for that powerpc patch, but it looks like you didn't
> merge it?

No, I missed that.  I've never had to do any serious merging with other
changes, so I've never had to do this before.  I can fix it if Linus
wants to wait.  Thanks for the heads up.

-corey

>
>   https://git.kernel.org/cgit/linux/kernel/git/mpe/linux.git/log/?h=topic/opal-ipmi
>
> The merge conflict between your tree and mine is not all that pretty, though
> Linus should be able to work it out. I haven't sent my pull request yet though,
> so he'll probably get it when he merges my tree.
>
> The patch in your tree does look correct, so that's OK, but maybe next time we
> can both merge the topic branch.
>
> cheers
>
>


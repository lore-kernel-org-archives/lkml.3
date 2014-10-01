Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaJAAaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 20:30:17 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:56875 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbaJAAaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 20:30:16 -0400
Message-ID: <542B4B16.6060401@nexus-software.ie>
Date: Wed, 01 Oct 2014 01:30:14 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, hpa@zytor.com, davej@redhat.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: Quark: Add legacy_cache_size and TLB comments
References: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1410010153590.4455@nanos>
In-Reply-To: <alpine.DEB.2.11.1410010153590.4455@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/14 01:11, Thomas Gleixner wrote:
> Bryan,
>
> On Wed, 1 Oct 2014, Bryan O'Donoghue wrote:
>
> what are you trying to achieve by sending out patches faster than
> anyone can review?

Thomas.

That's not the intention at all.

> Doing this has an obvious outcome:
>
>    1) The patches you whip up 10 seconds after the review hits your
>       inbox are likely not to be well thought out. Neither are the
>       changelogs.
>
>       Just by skimming the lot I noticed at least two issues which you
>       just mechanically fixed up without applying any thought. I'm not
>       going to tell you, simply because you are starting to abuse and
>       waste my time.
>
>    2) Keeping #1 as your modus operandi will make sure that you get on
>       the backlog list of reviewers and maintainers and in the worst
>       case on the shitlist.

1)
OK, I take your point on the frequency.

2)
On the substance.
I'm certainly not trying to antagonise you here - I assumed you were 
*suggesting* to apply those comments directly ?
Which is why I updated the sent patches with your comments - since they 
seemed more descriptive anyway - and sent back to the list.


Thanks,
Bryan

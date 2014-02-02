Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaBBHFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 02:05:14 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43061 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaBBHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 02:05:11 -0500
Message-ID: <52EDEE17.4010205@landley.net>
Date: Sun, 02 Feb 2014 01:04:55 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Henrik Austad <henrik@austad.us>, LKML doc <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] Documentation cleanup, update 00-INDEX files in Documentation/
References: <1391041675-31683-1-git-send-email-henrik@austad.us>	<52E9D3EB.1060209@landley.net> <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
In-Reply-To: <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/14 16:24, Andrew Morton wrote:
> On Wed, 29 Jan 2014 22:24:11 -0600 Rob Landley <rob@landley.net> wrote:
>
>> On 01/29/14 18:27, Henrik Austad wrote:
>>> Some of the 00-INDEX files are somewhat outdated and some folders does not
>>> contain 00-INDEX at all. Only outdated (with the notably exception of
>>> spi) indexes are touched here, the 169 folders without 00-INDEX has not
>>> been touched.
>>>
>>> This applies to Linus' tip (0e47c969).
>>
>> Looks like an improvement.
>>
>> Acked-by: Rob Landley <rob@landley.net>
>
> Are these 00-INDEX files actually useful?  I've never opened one of
> them in my life.

Back before kernel.org did its epic barn door locking after the horses 
escaped, I used to use them to generate HTML indexes for 
kernel.org/doc/Documentation, but sometime after they took away my 
ability to rsync updates to that they replaced that directory with a raw 
git checkout. I'm still waiting for them to replace the HTML versions of 
the menuconfig help text and the htmldocs output with raw git checkouts too.

I periodically poke them about it, ala 
https://bugzilla.kernel.org/show_bug.cgi?id=52721#c7 but the answer is 
always crickets chirping or "you should upload web pages with git just 
like you browse the web with git, watch video with git, play skyrim with 
git, edit code with git, compile code with git... there is no other 
software tool." At which point I wander off for another 6 months.

So I used to have a use for it, but since kernel.org got all paranoid I 
can't use it that way anymore. (That's why I haven't been updating these 
files when the patches themselves don't. It's on my todo list, but it's 
really hard to _care_ when they so obviously don't.)

Insufficiently gruntled,

Rob

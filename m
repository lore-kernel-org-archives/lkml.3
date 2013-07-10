Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3GJTBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:01:08 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44152 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJTBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:01:06 -0400
Date: Wed, 10 Jul 2013 12:01:05 -0700 (PDT)
Message-Id: <20130710.120105.2012285003242857716.davem@davemloft.net>
To: mtk.manpages@gmail.com
Cc: eliezer.tamir@linux.intel.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, eliezer@tamir.org.il
Subject: Re: [PATCH v2] socket.7: add description for SO_BUSY_POLL
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAKgNAkhk+K=t0fu12Q03wcp18JrNsudTpEYs4=XP8KF81918ZQ@mail.gmail.com>
References: <51DDA1DC.2020306@gmail.com>
	<20130710.115215.1793423861402826221.davem@davemloft.net>
	<CAKgNAkhk+K=t0fu12Q03wcp18JrNsudTpEYs4=XP8KF81918ZQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 10 Jul 2013 20:57:16 +0200

> On Wed, Jul 10, 2013 at 8:52 PM, David Miller <davem@davemloft.net> wrote:
>> From: Michael Kerrisk <mtk.manpages@gmail.com>
>> Date: Wed, 10 Jul 2013 20:03:08 +0200
>>
>>> On 07/10/13 16:18, Eliezer Tamir wrote:
>>>> Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.
>>>>
>>>> v2
>>>> fixed typos reported by Rasmus Villemoes
>>>
>>> Eliezer,
>>>
>>> What's the status of this feature. A quick grep seems to show
>>> that the feature is not yet in mainline. What is the plan?
>>
>> It's in Linus's tree.
> 
> That doesn't appear to be the case. grepping current Linus Git for
> SO_BUSY_POLL yields nada. What am I missing?

In the same set of postings Eliezer made with this manpage patch, he
also posted kernel patches which rename the socket option to it's
final name.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3GJS5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:57:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35420 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:57:36 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20130710.115215.1793423861402826221.davem@davemloft.net>
References: <20130710141835.15799.61657.stgit@ladj378.jer.intel.com>
 <51DDA1DC.2020306@gmail.com> <20130710.115215.1793423861402826221.davem@davemloft.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 10 Jul 2013 20:57:16 +0200
Message-ID: <CAKgNAkhk+K=t0fu12Q03wcp18JrNsudTpEYs4=XP8KF81918ZQ@mail.gmail.com>
Subject: Re: [PATCH v2] socket.7: add description for SO_BUSY_POLL
To: David Miller <davem@davemloft.net>
Cc: eliezer.tamir@linux.intel.com, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, eliezer@tamir.org.il
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 8:52 PM, David Miller <davem@davemloft.net> wrote:
> From: Michael Kerrisk <mtk.manpages@gmail.com>
> Date: Wed, 10 Jul 2013 20:03:08 +0200
>
>> On 07/10/13 16:18, Eliezer Tamir wrote:
>>> Add description for the SO_BUSY_POLL socket option to the socket(7) manpage.
>>>
>>> v2
>>> fixed typos reported by Rasmus Villemoes
>>
>> Eliezer,
>>
>> What's the status of this feature. A quick grep seems to show
>> that the feature is not yet in mainline. What is the plan?
>
> It's in Linus's tree.

That doesn't appear to be the case. grepping current Linus Git for
SO_BUSY_POLL yields nada. What am I missing?

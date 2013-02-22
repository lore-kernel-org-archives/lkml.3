Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3BVC0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:26:54 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52127 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3BVC0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:26:51 -0500
MIME-Version: 1.0
In-Reply-To: <5126313E.2060608@start.ca>
References: <20130220.170901.343210063003534302.davem@davemloft.net>
 <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com> <5126313E.2060608@start.ca>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 21 Feb 2013 21:26:19 -0500
X-Google-Sender-Auth: virJLrl8AneoGR2Ybww506MH8RY
Message-ID: <CAP=VYLoW2KfdWen6x0p+Kv_DbsDj=mHMdAZB5Mx_RkFZ7jk6fg@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Mark Lord <kernel@start.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 9:37 AM, Mark Lord <kernel@start.ca> wrote:
> On 13-02-20 10:05 PM, Linus Torvalds wrote:
>> On Wed, Feb 20, 2013 at 2:09 PM, David Miller <davem@davemloft.net> wrote:
>>>
>>> 15) Orphan and delete a bunch of pre-historic networking drivers from
>>>     Paul Gortmaker.
>>
>> Nooo.... You killed the 3c501 and 3c503 drivers! Snif.
>>
>> I wonder if they still worked..
>
> I hope they're not really dead, because we still use them in several machines here
> as secondary interfaces for test rigs and whatnot.
>
> It's a tad early to be nuking support for such widespread devices.

Hi Mark,

Did you actually look at the drivers deleted?  This was not a blanket
delete of _all_ ISA drivers, and I seriously doubt that you are using the
3c501 or 3c503 drivers.  To be clear, it was a very selective removal of
drivers from the early 1990's, and so the common ISA drivers for the
widespread devices (like 3c509, and 8390 shared memory implementations)
continue to exist in mainline today.

Someday we will delete them, but it was not done here at this point in
time, so I hope people do not get confused on that.

Paul.
--

>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

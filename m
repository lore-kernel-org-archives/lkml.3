Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3BVDyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 22:54:41 -0500
Received: from mouse.start.ca ([64.140.120.56]:43211 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab3BVDyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 22:54:37 -0500
Message-ID: <5126EBF9.9090107@start.ca>
Date: Thu, 21 Feb 2013 22:54:33 -0500
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
References: <20130220.170901.343210063003534302.davem@davemloft.net> <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com> <5126313E.2060608@start.ca> <CAP=VYLoW2KfdWen6x0p+Kv_DbsDj=mHMdAZB5Mx_RkFZ7jk6fg@mail.gmail.com>
In-Reply-To: <CAP=VYLoW2KfdWen6x0p+Kv_DbsDj=mHMdAZB5Mx_RkFZ7jk6fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-21 09:26 PM, Paul Gortmaker wrote:
> On Thu, Feb 21, 2013 at 9:37 AM, Mark Lord <kernel@start.ca> wrote:
>> On 13-02-20 10:05 PM, Linus Torvalds wrote:
>>> On Wed, Feb 20, 2013 at 2:09 PM, David Miller <davem@davemloft.net> wrote:
..
>>> Nooo.... You killed the 3c501 and 3c503 drivers! Snif.
>>>
>>> I wonder if they still worked..
>>
>> I hope they're not really dead, because we still use them in several machines here
>> as secondary interfaces for test rigs and whatnot.
..
> Did you actually look at the drivers deleted?
..

Finally got to one of the boxes here to check.
And you're right, I was confusing drivers.

I always seem to get the 3c509 (ISA) stuff confused with the 3c59x (PCI).
Our boxes here have the 3c59x (PCI) cards.

R.I.P. 3c50x.  :)

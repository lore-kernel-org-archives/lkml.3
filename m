Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3BUOhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:37:55 -0500
Received: from mouse.start.ca ([64.140.120.56]:41608 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3BUOhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:37:54 -0500
Message-ID: <5126313E.2060608@start.ca>
Date: Thu, 21 Feb 2013 09:37:50 -0500
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
References: <20130220.170901.343210063003534302.davem@davemloft.net> <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com>
In-Reply-To: <CA+55aFz=tzf9a-SY1CqCAxsqRDz=ebE69YoZ30at6kHeKKhsaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-20 10:05 PM, Linus Torvalds wrote:
> On Wed, Feb 20, 2013 at 2:09 PM, David Miller <davem@davemloft.net> wrote:
>>
>> 15) Orphan and delete a bunch of pre-historic networking drivers from
>>     Paul Gortmaker.
> 
> Nooo.... You killed the 3c501 and 3c503 drivers! Snif.
> 
> I wonder if they still worked..

I hope they're not really dead, because we still use them in several machines here
as secondary interfaces for test rigs and whatnot.

It's a tad early to be nuking support for such widespread devices.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaAFJoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:44:32 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:9614 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaAFJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:44:30 -0500
Message-ID: <52CA7AFB.9010208@atmel.com>
Date: Mon, 6 Jan 2014 10:44:27 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Simon Horman <horms@verge.net.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: linux-next: manual merge of the renesas tree with the arm-soc
 tree
References: <20131216104738.6f845aabd0e3b609ed9ca170@canb.auug.org.au>	<52AECF56.8020508@atmel.com> <CAOesGMgi3COtsr+-9B3Tt350gwBs0Qm0AjatjLWCWTeUkAP5og@mail.gmail.com>
In-Reply-To: <CAOesGMgi3COtsr+-9B3Tt350gwBs0Qm0AjatjLWCWTeUkAP5og@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 06:11, Olof Johansson :
> On Mon, Dec 16, 2013 at 2:00 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>> On 16/12/2013 00:47, Stephen Rothwell :
>>> Hi Simon,
>>>
>>> Today's linux-next merge of the renesas tree got a conflict in
>>> drivers/clk/Makefile between commit 0ad6125b1579 ("clk: at91: add PMC
>>> base support") from the arm-soc tree and commit 10cdfe9f327a ("clk:
>>> shmobile: Add R-Car Gen2 clocks support") from the renesas tree.
>>>
>>> I fixed it up (see below) and can carry the fix as necessary (no action
>>> is required).
>>
>> Fine for me.
> 
> Simon, Nicolas,
> 
> <mini-rant>
> 
> While a very minor issue, this should have been altogether avoided
> with a little more attention when applying patches. The Makefile is
> sorted, and you've appended new lines to the end instead of in the
> place they're supposed to go. Sure, others have done the same mistake
> in a few places but that doesn't mean we shouldn't try to keep it
> sorted.
> 
> The very reason _to_ sort a Makefile is to avoid these needless
> add-add conflicts when two people append to the same unsorted list.
> 
> Now I can't resolve it properly and move the entries when I do the
> same merge (and get the same conflict), because that will cause a
> third conflict for Stephen, and he's about to return from vacation and
> is going to cuss at us if we cause too many new conflicts in one day.
> :)
> 
> </mini-rant>
> 
> So, best choice is to keep the unsortedness now, and have Mike resort
> his Makefile for us at the end of the merge window. And keep a little
> closer eye on Makefile and Kconfig additions in the future. :)

Totally agree in keeping a Makefile sorted, when it is already sorted.
What I recall having thought when I had seen this Makefile is: well this
one must be of the "append your changes to the end" type...

Anyway be sure that I will pay attention to this.

Bye,
-- 
Nicolas Ferre

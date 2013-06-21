Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423308Ab3FUPak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:30:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43038 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423278Ab3FUPai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:30:38 -0400
Message-ID: <51C4703C.10206@ti.com>
Date: Fri, 21 Jun 2013 10:24:44 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, Olof Johansson <olof@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mailbox
 tree
References: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au> <CAOesGMjszju75jo6Ej6C=0-rfdPLuEj0mwmU1zYvFvYw1dyQCA@mail.gmail.com> <20130621071239.GM5523@atomide.com> <201306210936.09593.arnd@arndb.de>
In-Reply-To: <201306210936.09593.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On 06/21/2013 02:36 AM, Arnd Bergmann wrote:
> On Friday 21 June 2013, Tony Lindgren wrote:
>>> I wonder if this mess is caused by the fact that I did the revert
>>> instead of rebuilding our for-next and dropping the merge in the first
>>> place.
>>>
>>> I'll rebuild our for-next (or maybe Arnd will beat me to it) before
>>> next linux-next build, i.e. Sunday night my time.
>>
>> Could be, especially if some of the commits are the same in the reverted
>> branch and newly merged branch as git might think that some merges have
>> been already resolved the right way earlier.

Yes, please drop the particular mailbox branch that you were picking
into linux-next. It was the previous framework which was dropped at the
last minute during the 3.10 merge window in favor of new one still under
its final development steps, so we will not be using any commits from
that branch.  Sorry for the trouble on this one. The branch that Arnd
took has some of the OMAP patches reworked in preparation for the
newer one.

> 
> I already rebuilt the arm-soc tree before Stephen started with today's
> linux-next, so I think the conflict is elsewhere.
> 
> It's probably best if Suman Anna rebases the mailbox tree on top of
> the omap mailbox branch that I took.
> 

I will rebase the mailbox tree once we have the new patches from Jassi
finalized.

regards
Suman


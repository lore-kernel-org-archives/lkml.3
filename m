Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaHHOdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:33:07 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44280 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaHHOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140808103021.GA30282@n2100.arm.linux.org.uk>
References: <CAJe_ZhdZTSs+Ns4u7bMXwbLHYTnE-5XEE8uev4zXbXrCP52bSg@mail.gmail.com>
	<20140808142912.7bf68229@canb.auug.org.au>
	<20140808103021.GA30282@n2100.arm.linux.org.uk>
Date: Fri, 8 Aug 2014 20:03:01 +0530
Message-ID: <CAJe_Zhcy+CjXa218gWNFR=O1U7g3iXGQ8s+VwgoGKamk3ysoKw@mail.gmail.com>
Subject: Re: Request to include Mailbox tree in linux-next
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Mollie Wu <mollie.wu@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2014 16:00, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Fri, Aug 08, 2014 at 02:29:12PM +1000, Stephen Rothwell wrote:
>> Hi Jassi,
>>
>> On Wed, 6 Aug 2014 12:25:49 +0530 Jassi Brar <jaswinder.singh@linaro.org> wrote:
>> >
>> >  The framework for Mailbox has undergone 10 revisions over the last
>> > one year, which has garnered support in the form of 'Reviewed-by' and
>> > 'looks good enough to be merged in this window' from people in the CC
>> > list.
>> >
>> >   Could you please add it to linux-next?
>> > Tree:       git://git.linaro.org/landing-teams/working/fujitsu/integration.git
>> > Branch:   mailbox-for-3.17
>> > Contact:  Jassi Brar <jaswinder.singh@linaro.org>
>>
>> This is really late for v3.17.  The purpose of linux-next is to
>> discover interactions between trees before they are pulled into Linus'
>> tree and to do some cross architecture build checking.  Adding a tree
>> during the merge window is not very helpful to that.
>
> +1.
>
> The same goes for any tree which is part of linux-next.
>
> Having a tree in linux-next carries with it the responsibility that the
> tree owner abides by the kernel development cycle, which includes
> respecting the moratorium on merging new development into branch(es)
> which are part of linux-next during an actively open merge window.
>
I wasn't aware that any new subsystem must live at least one cycle in
linux-next, I submitted it for inclusion just because someone
suggested that as the next best thing to merging this cycle.

Thanks
-Jassi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaHHOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:25:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53949 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaHHOZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:25:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140808142912.7bf68229@canb.auug.org.au>
References: <CAJe_ZhdZTSs+Ns4u7bMXwbLHYTnE-5XEE8uev4zXbXrCP52bSg@mail.gmail.com>
	<20140808142912.7bf68229@canb.auug.org.au>
Date: Fri, 8 Aug 2014 19:55:52 +0530
Message-ID: <CAJe_ZhceR1j_b-_efJoq9Dv6X6C=UuMgyp8AofjcCvc+bQVkfw@mail.gmail.com>
Subject: Re: Request to include Mailbox tree in linux-next
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Andy Green <andy.green@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2014 09:59, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jassi,
>
> On Wed, 6 Aug 2014 12:25:49 +0530 Jassi Brar <jaswinder.singh@linaro.org> wrote:
>>
>>  The framework for Mailbox has undergone 10 revisions over the last
>> one year, which has garnered support in the form of 'Reviewed-by' and
>> 'looks good enough to be merged in this window' from people in the CC
>> list.
>>
>>   Could you please add it to linux-next?
>> Tree:       git://git.linaro.org/landing-teams/working/fujitsu/integration.git
>> Branch:   mailbox-for-3.17
>> Contact:  Jassi Brar <jaswinder.singh@linaro.org>
>
> This is really late for v3.17.  The purpose of linux-next is to
> discover interactions between trees before they are pulled into Linus'
> tree and to do some cross architecture build checking.  Adding a tree
> during the merge window is not very helpful to that.
>
> However if this is really going to be merged by Linus before v3.17-rc1,
> I will add it on Monday, OK?
>
The patchset was deemed ready enough for this merge window. However
some late nitpicks and bikeshedding discussions ate time and my
confidence to send a pull request to Linus. Upon Mark's suggestion
(and the right thing to do) I wanted the patchset to live the cycle in
linux-next.
 Sorry, I messed up by calling it for-3.17. It should have been for-3.18.

Regards,
-Jassi

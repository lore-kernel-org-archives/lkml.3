Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbbAVJg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:36:29 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:62970 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbAVJgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1501211510220.10817@pobox.suse.cz>
References: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<alpine.LNX.2.00.1501201407050.10817@pobox.suse.cz>
	<CAMk6uBk8gPAsKKqZPC=9dxRkiXm7893SwK1fd6J4Bc+iVkG+uA@mail.gmail.com>
	<alpine.LNX.2.00.1501211510220.10817@pobox.suse.cz>
Date: Thu, 22 Jan 2015 17:36:20 +0800
Message-ID: <CAMk6uBk+9egRDqyUWRR=1BM8Vu-qG7sj5NMsd9OR-7OrZ6LznA@mail.gmail.com>
Subject: Re: [PATCH] blackfin: mach-common: ints-priority: Remove unused function
From: Steven Miao <realmz6@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Randy Dunlap <rdunlap@infradead.org>, Christoph Lameter <cl@linux.com>,
        Masanari Iida <standby24x7@gmail.com>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:11 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 21 Jan 2015, Steven Miao wrote:
>
>> > This doesn't seem to be present in linux-next as of today, so I am picking
>> > it up.
>> It seems it's still in today's linux-next?
>> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/blackfin/mach-common/ints-priority.c#n432
>
> Your "today" probably differs from mine :) The commit that removes it has
> appeared in linux-next ~6 hours ago.
>
> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=4d2ffaa99c7a685dabab5c8c56b58286fd679bd5
Yes, it is. There could be several hours delay from mine :)
>
> --
> Jiri Kosina
> SUSE Labs

-steven

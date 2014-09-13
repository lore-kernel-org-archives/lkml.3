Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaIMODj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 10:03:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36010 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaIMODi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 10:03:38 -0400
Message-ID: <54144EAC.8030101@oracle.com>
Date: Sat, 13 Sep 2014 10:03:24 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: Re: [PATCH v2 4/6] mm: introduce common page state for ballooned
 memory
References: <20140830163834.29066.98205.stgit@zurg>	<20140830164120.29066.8857.stgit@zurg>	<20140912165143.86d5f83dcde4a9fd78069f79@linux-foundation.org> <CALYGNiM0Uh1KG8Z6pFEAn=uxZBRPfHDffXjKkKJoG-K0hCaqaA@mail.gmail.com>
In-Reply-To: <CALYGNiM0Uh1KG8Z6pFEAn=uxZBRPfHDffXjKkKJoG-K0hCaqaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2014 01:26 AM, Konstantin Khlebnikov wrote:
>> Did we really need to put the BalloonPages count into per-zone vmstat,
>> > global vmstat and /proc/meminfo?  Seems a bit overkillish - why so
>> > important?
> Balloon grabs random pages, their distribution among numa nodes might
> be important.
> But I know nobody who uses numa-aware vm together with ballooning.

*cough*. me?

Obviously there's no need to keep that per-zone vmstat just for me, but
right now NUMA on KVM works just fine and does a good job of catching
NUMA issues without having to run on actual metal.


Thanks,
Sasha

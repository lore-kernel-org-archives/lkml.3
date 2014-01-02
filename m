Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849AbaABBgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:36:22 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:1832 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaABBgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:36:21 -0500
Message-ID: <52C4C216.3070607@huawei.com>
Date: Thu, 2 Jan 2014 09:34:14 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Vegard Nossum" <vegardno@ifi.uio.no>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        <wangnan0@huawei.com>, the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: add a new command-line kmemcheck value
References: <52C2811C.4090907@huawei.com> <CAOMGZ=GOR_i9ixvHeHwfDN1wwwSQzFNFGa4qLZMhWWNzx0p8mw@mail.gmail.com>
In-Reply-To: <CAOMGZ=GOR_i9ixvHeHwfDN1wwwSQzFNFGa4qLZMhWWNzx0p8mw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/31 18:12, Vegard Nossum wrote:

> (Oops, resend to restore Cc.)
> 
> Hi,
> 
> On 31 December 2013 09:32, Xishi Qiu <qiuxishi@huawei.com> wrote:
>> Add a new command-line kmemcheck value: kmemcheck=3 (disable the feature),
>> this is the same effect as CONFIG_KMEMCHECK disabled.
>> After doing this, we can enable/disable kmemcheck feature in one vmlinux.
> 
> Could you please explain what exactly the difference is between the
> existing kmemcheck=0 parameter and the new kmemcheck=3?
> 
> Thanks,
> 
> 
> Vegard
> 

Hi Vegard,

kmemcheck=0: enable kmemcheck feature, but don't check the memory.
	and the OS use only one cpu.(setup_max_cpus = 1)
kmemcheck=3: disable kmemcheck feature.
	this is the same effect as CONFIG_KMEMCHECK disabled.
	OS will use cpus as many as possible.

Thanks,
Xishi Qiu





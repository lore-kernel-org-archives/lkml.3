Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3KFBNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:13:45 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:59032 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab3KFBNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:13:44 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rA61DF6D017703, This message is accepted by code: ctloc85258
Message-ID: <52799813.9050302@realsil.com.cn>
Date: Wed, 6 Nov 2013 09:14:59 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <oakad@yahoo.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] memstick: rtsx: fix ms card data transfer bug
References: <1383115216-11967-1-git-send-email-micky_ching@realsil.com.cn> <20131105131027.4ce3bc298266bd82104f5fce@linux-foundation.org>
In-Reply-To: <20131105131027.4ce3bc298266bd82104f5fce@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MS card can not use auto read/write mode, so it will fail at
initialize and long data transfer. This patch is used to add
support for ms card.

Shall I re-send this patch to add more info?

On 11/06/2013 05:10 AM, Andrew Morton wrote:
> On Wed, 30 Oct 2013 14:40:16 +0800 <micky_ching@realsil.com.cn> wrote:
>
>> unlike mspro card, ms card use normal read/write mode for DMA
>> data transfer.
> What are the user-visible effects of this bug?
>
> Please always include this information when fixing bugs so that others
> can decide whether they (or their customers) need the patch.
>
> .
>


-- 
Best Regards
Micky.


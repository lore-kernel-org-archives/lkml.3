Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3JNH2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:28:17 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27305 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3JNH2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:28:16 -0400
Message-ID: <525B9CEC.5000903@huawei.com>
Date: Mon, 14 Oct 2013 15:27:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] slub: Fix calculation of cpu slabs
References: <522E9569.9060104@huawei.com> <0000014109b29246-61170b4a-7ab7-41f0-a887-a1cd62603196-000000@email.amazonses.com>
In-Reply-To: <0000014109b29246-61170b4a-7ab7-41f0-a887-a1cd62603196-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

could you pick up this patch?

On 2013/9/11 5:06, Christoph Lameter wrote:
> On Tue, 10 Sep 2013, Li Zefan wrote:
> 
>> We should use page->pages instead of page->pobjects when calculating
>> the number of cpu partial slabs. This also fixes the mapping of slabs
>> and nodes.
> 
> True.
> 
>> As there's no variable storing the number of total/active objects in
>> cpu partial slabs, and we don't have user interfaces requiring those
>> statistics, I just add WARN_ON for those cases.
> 
> 
> Well that is not strictly required but it does not hurt either.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaAMJio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:38:44 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:58819 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMJil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:38:41 -0500
Message-ID: <52D3B411.70106@profitbricks.com>
Date: Mon, 13 Jan 2014 10:38:25 +0100
From: Jack Wang <jinpu.wang@profitbricks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [STABLE] find missing bug fixes in a stable kernel
References: <52D3958B.1060902@huawei.com>
In-Reply-To: <52D3958B.1060902@huawei.com>
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 08:28 AM, Li Zefan wrote:
> We have several long-term and extended stable kernels, and it's possible
> that a bug fix is in some stable versions but is missing in some other
> versions, so I've written a script to find out those fixes.
> 
> Take 3.4.xx and 3.2.xx for example. If a bug fix was merged into upstream
> kernel after 3.4, and then it was backported to 3.2.xx, then it probably
> needs to be backported to 3.4.xx.
> 
> The result is, there're ~430 bug fixes in 3.2.xx that probably need to be
> backported to 3.4.xx. Given there're about 4500 commits in 3.2.xx, that
> is ~10%, which is quite a big number for stable kernels.
> 
> We (our team in Huawei) are going to go through the whole list to filter
> out fixes that're applicable for 3.4.xx.
> 
> I've attached the lists for 3.4 and 3.10.
> 
> If a commit ID appears more than once in changelogs, it's possible that's
> because the commit was reverted later, so I tagged this kind of commits
> in the lists.
> 
Hello Zefan,

Thanks for share, great job, it's very useful info for other companies
who build their kernel base on long term kernel like here in ProfitBricks.

I'm a little confused about the column occurrences, what do the 2
numbers mean, eg :
8c4f3c3fa968 874d3954a35c 2 1
the first is the occurrences in upstream and second for the occurrence
in 3.2.xx right?

Regards,
Jack




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaEIHll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:41:41 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:61039 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaEIHlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:41:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140509071423.GF5767@lee--X1>
References: <20140509134455.07d7de4d@canb.auug.org.au>
	<20140509071423.GF5767@lee--X1>
Date: Fri, 9 May 2014 09:41:39 +0200
Message-ID: <CAPDyKFq1O-bB1Vax0uRKaF2p2AJ1FXHC6LNoLsooGx5gBdsuLA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mmc tree with Linus' tree
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lee Jones <lee.jones@linaro.org>, Chris Ball <chris@printf.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Micky Ching <micky_ching@realsil.com.cn>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2014 09:14, Lee Jones <lee.jones@linaro.org> wrote:
>> Today's linux-next merge of the mmc tree got a conflict in
>> drivers/mmc/host/rtsx_pci_sdmmc.c between commit 98fcc5762dce ("mmc:
>> rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"") from
>> the  tree and commit 1f7b581b3ffc ("mmc: rtsx: modify error handle and
>> remove smatch warnings") from the mmc tree.
>>
>> I fixed it up (maybe - see below and in the final tree) and can carry
>> the fix as necessary (no action is required).
>
> FYI: From what Ulf (co-maintainer of MMC) says, this was expected and
> will continue to happen until a pending revert is merged.
>

Hi Stehpen,

Within this context; while Chris is being busy, I would be able to
help out better as co-maintainer - if we would add my published mmc
git tree, into your linux-next merge. Could you do that?

My intent at this point, is to get patches tested in linux-next, but
still get them merged via Chris' mmc tree. Does that make sense?

Here is my git tree:
git://git.linaro.org/people/ulf.hansson/mmc.git

I have added a next branch, currently it points to the commit for
"Linux 3.15-rc4", so it holds no patches yet.

Kind regards
Ulf Hansson

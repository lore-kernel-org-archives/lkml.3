Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab3HFEZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 00:25:46 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61690 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3HFEZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 00:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130805232337.5348.79716@quantum>
References: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
	<1373197462-4033-2-git-send-email-yadi.brar@samsung.com>
	<20130805232337.5348.79716@quantum>
Date: Tue, 6 Aug 2013 09:55:44 +0530
Message-ID: <CAKew6eXRuB5Q0f_GaCKOR7XwbX0n=-5BR_TeRVMUCD9AUHiL7w@mail.gmail.com>
Subject: Re: [PATCH 1/3] clk: s2mps11: Add support for s2mps11
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        sbkim73@samsung.com, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Aug 6, 2013 at 4:53 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Yadwinder Singh Brar (2013-07-07 04:44:20)
>> This patch adds support to register three(AP/CP/BT) buffered 32.768 KHz
>> outputs of mfd-s2mps11 with common clock framework.
>>
>> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
>
> Yadwinder,
>
> Looks good to me with the exception of a binding description document.
> Can you provide one and squash it into this commit?
>

Binding description is provided in next patch :
[PATCH 2/3] mfd: sec: Add clock cell for s2mps11  :
https://lkml.org/lkml/2013/7/16/228

Since its a MFD, so i preferred to add documentation in same file
under mfd, same was done for regulators also.
If its fine with you then, I think that patch can go through MFD tree
as same file is touched in for-next of MFD tree.


Thanks,
Yadwinder

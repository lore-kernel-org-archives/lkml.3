Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379Ab3DCDcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:32:12 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:59685 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760427Ab3DCDcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130402164042.GB25867@quad.lixom.net>
References: <1363167315-12753-1-git-send-email-sachin.kamat@linaro.org>
	<20130402164042.GB25867@quad.lixom.net>
Date: Wed, 3 Apr 2013 09:02:09 +0530
Message-ID: <CAK9yfHwFgSouhL_dBfjoNFVb-CzQ+rF2q6TVWruzAt0mdScn0A@mail.gmail.com>
Subject: Re: [PATCH 1/1] irqchip: irq-gic: Fix checkpatch errors
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2013 22:10, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Mar 13, 2013 at 03:05:15PM +0530, Sachin Kamat wrote:
>> Fixes the following errors:
>> ERROR: do not initialise statics to 0 or NULL
>> ERROR: space required after that ',' (ctx:VxV)
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>> Compile tested and based on linux-next tree (20130313).
>
> I haven't seen this show up in linux-next through Thomas, so I've applied it to
> our next/cleanup branch.

Thanks Olof.
Would you also be taking the patch at [1] as I havent heard back on
that one too.
Please let me know if you want me to resend this one as I had not
marked you in CC earlier.

[1] https://lkml.org/lkml/2013/3/13/107

-- 
With warm regards,
Sachin

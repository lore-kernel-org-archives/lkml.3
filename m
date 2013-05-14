Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab3ENVB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:01:29 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44359 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab3ENVB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:01:28 -0400
Message-ID: <5192A61E.5020605@imgtec.com>
Date: Tue, 14 May 2013 22:01:18 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <20130513195746.10068.92303@quantum> <CAAG0J991BCziPFddzBrx9vcwRxyRgcCd38A01uKXTDDK9xTnbQ@mail.gmail.com> <20130514165937.10068.18501@quantum>
In-Reply-To: <20130514165937.10068.18501@quantum>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_14_22_01_26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 14/05/13 17:59, Mike Turquette wrote:
> Quoting James Hogan (2013-05-13 14:30:46)
>> On 13 May 2013 20:57, Mike Turquette <mturquette@linaro.org> wrote:
>>> One reason for this is the difficulty some have had with setting flags
>>> from DT bindings.
>>
>> Could you elaborate on this? I've been adding flags to DT bindings for
>> this sort of thing, but it feels a bit like it's in that grey area of
>> not really describing the hardware itself. This information needs to
>> be specified somehow though.
>>
> 
> It depends on the flag.  A good example is the CLK_DIVIDER_ONE_BASED
> flag which does describe the hardware.  It informs the binding that
> indexing starts at 1, not 0, which is a valid part of the hardware
> description.
> 
> However flags that deal with software policy do not belong on DT.
> CLK_SET_RATE_PARENT certainly does not belong in the DT binding since
> this is a pure Linux-ism.  Every binding just needs to be reviewed on a
> case-by-case basis to make sure the flags are related only to the
> hardware.

So given the desire to eliminate platform code, is there a particular
way that these other flags can be specified instead of DT bindings?

Cheers
James


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaB0IfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:35:24 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47108 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaB0IfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:35:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140226211150.12081.99155@quantum>
References: <1392791076-28301-1-git-send-email-tushar.behera@linaro.org>
	<20140226211150.12081.99155@quantum>
Date: Thu, 27 Feb 2014 14:05:18 +0530
Message-ID: <CAHbNUh3JA0_AL_OdX3prp-=Y9xby7-96NPgEQUiyDQ=NEsb7hg@mail.gmail.com>
Subject: Re: [PATCH V2 0/2] Add support for clocks in S5M8767
From: Tushar Behera <tushar.behera@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2014 02:41, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Tushar Behera (2014-02-18 22:24:34)
>> S5M8767 chip has 3 crystal oscillators which are operated in the same
>> as the crystal oscillators in S2MPS11. Extend s2mps11-clk driver to
>> support clocks in S5M8767.
>>
>> The patches are rebased on top of next-20130218.
>
> These changes look good to me. Will these get picked up as part of a
> Samsung clk pull request or would you prefer that I pick them
> individually?
>
Mike,

Please pick these patches. They won't be part of Samsung clk pull request.

> Regards,
> Mike
>
>>
>> Tushar Behera (2):
>>   clk: clk-s2mps11: Refactor for including support for other MFD clocks
>>   clk: clk-s2mps11: Add support for clocks in S5M8767 MFD
>>
>>  drivers/clk/Kconfig       |    6 ++++--
>>  drivers/clk/clk-s2mps11.c |   25 +++++++++++++++++++++----
>>  2 files changed, 25 insertions(+), 6 deletions(-)
>>
>> --
>> 1.7.9.5
>>



-- 
Tushar Behera

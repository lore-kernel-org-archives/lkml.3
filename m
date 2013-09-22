Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3IVKMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:12:43 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45190 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3IVKMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:12:41 -0400
Message-ID: <523EDEB0.1060601@gmail.com>
Date: Sun, 22 Sep 2013 14:12:32 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Barry Song <21cnbao@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, Barry Song <baohua.song@csr.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 04/26] clk: prima2: declare OF clock provider
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-5-git-send-email-sebastian.hesselbarth@gmail.com> <CAGsJ_4xC_g1C-pGQGrcLOBhKLSMG3D8369DRPoFgNZhKqs-aTQ@mail.gmail.com> <523ABA7A.50305@gmail.com>
In-Reply-To: <523ABA7A.50305@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 10:48 AM, Sebastian Hesselbarth wrote:
> On 09/19/13 10:45, Barry Song wrote:
>>> @@ -1124,3 +1106,4 @@ void __init sirfsoc_of_clk_init(void)
>>>
>>>          of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
>>>   }
>>> +CLK_OF_DECLARE(sirfsoc_clk, "sirf,prima2-clkc", sirfsoc_clk_init);
>>
>> hi Sebastian,
>> what if the driver is compatible with multiple clk controllers and we
>> want to add another compatible string here except "sirf,prima2-clkc"?
>>
>> -barry
>>
>
> Just add
> CLK_OF_DECLARE(other_fancy_clk, "sirf,different-compatible",
> sirfsoc_clk_init);

Barry, BTW, do I get your Acked-By for this and the corresponding
removal patch?

Sebastian


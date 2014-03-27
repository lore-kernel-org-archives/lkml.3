Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaC0I3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:29:11 -0400
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1105 "EHLO
	smtp-out-085.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753830AbaC0I3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:29:08 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4661
Message-ID: <5333E181.60607@metafoo.de>
Date: Thu, 27 Mar 2014 09:29:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] clk: axi-clkgen: Add support for v2
References: <1392629513-6114-1-git-send-email-lars@metafoo.de> <20140227010421.12081.82707@quantum> <530ED945.2050907@metafoo.de> <20140327023817.5762.48198@quantum>
In-Reply-To: <20140327023817.5762.48198@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 03:38 AM, Mike Turquette wrote:
> Quoting Lars-Peter Clausen (2014-02-26 22:20:53)
>> On 02/27/2014 02:04 AM, Mike Turquette wrote:
>>> Quoting Lars-Peter Clausen (2014-02-17 01:31:53)
>>>> This patch adds support for the new v2 version of the axi-clkgen core.
>>>> Unfortunately the method of accessing the registers is quite different on v2,
>>>> while the content still stays largely the same. So the patch adds a small
>>>> abstraction layer which implements the specific read and write functions for v1
>>>> and v2 in callback functions.
>>>
>>> Hi,
>>>
>>> This patch almost doubles the size of clk-axi-clkgen.c. Should it be a
>>> separate clock driver? I guess that depends on the relationship between
>>> "v1" and "v2". Are both of those versions of the clkgen core going into
>>> production?
>>
>> Hi,
>>
>> The only thing that is different between the two versions is how the PLL
>> registers are accessed. The content that is written to those register is a
>> 100% identical. So splitting it up into two drivers makes no sense, since
>> you'd have to copy&paste all the application logic. Both versions of the
>> core can be found in the wild.
>
> Hi Lars,
>
> I took this into clk-next some time ago but never replied to this thread
> letting you know. Better late than never :-)

Yep, already saw it showing up in clk-next a while ago, thanks.

- Lars


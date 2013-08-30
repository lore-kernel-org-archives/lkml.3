Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3H3HGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:06:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52657 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3H3HGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:06:07 -0400
Message-ID: <5220443E.3050205@ti.com>
Date: Fri, 30 Aug 2013 10:05:34 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/5] clk: dt: bindings for mux, divider & gate clocks
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <521F91B0.6030204@ti.com>
In-Reply-To: <521F91B0.6030204@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 09:23 PM, Santosh Shilimkar wrote:
> Mike,
>
> On Thursday 22 August 2013 01:53 AM, Mike Turquette wrote:
>> This series introduces binding definitions for common register-mapped
>> clock multiplexer, divider and gate IP blocks along with the
>> corresponding setup functions for matching DT data.  The bindings are
>> similar to the struct definitions but please don't hold that against the
>> binding: the struct definitions closely model the hardware register
>> layout.
>>
>> The delta from v3 is very small and only consists of cosmetic changes
>> and one functional change for better error handling.
>>
>> Changes since v3:
>> * added Tested-by & Reviewed-by from Heiko
>> * replaced underscores with dashes in DT property names
>> * bail from of clock setup function early if of_iomap fails
>> * removed unecessary explict cast
>>
>> Mike Turquette (5):
>>    clk: divider: replace bitfield width with mask
>>    clk: of: helper for determining number of parent clocks
>>    clk: dt: binding for basic multiplexer clock
>>    clk: dt: binding for basic divider clock
>>    clk: dt: binding for basic gate clock
>>
> I have used $subject series as the base for the Keystone
> ccf support and tested these patches on Keystone EVM. Will
> post those patches soon on the lists.
>
> For the series if you need more tested-by tags, feel free to
> add,
> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
>

Oh yea, same for my set I posted yesterday. Used this as basis for 
O3/O4/O5/DRA7/AM335x tests, so you can also add my Tested-by tag if you 
need one.

-Tero


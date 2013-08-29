Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3H2SYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:24:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39615 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab3H2SYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:24:16 -0400
Message-ID: <521F91B0.6030204@ti.com>
Date: Thu, 29 Aug 2013 14:23:44 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Boyd <sboyd@codeaurora.org>, Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/5] clk: dt: bindings for mux, divider & gate clocks
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
In-Reply-To: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Thursday 22 August 2013 01:53 AM, Mike Turquette wrote:
> This series introduces binding definitions for common register-mapped
> clock multiplexer, divider and gate IP blocks along with the
> corresponding setup functions for matching DT data.  The bindings are
> similar to the struct definitions but please don't hold that against the
> binding: the struct definitions closely model the hardware register
> layout.
> 
> The delta from v3 is very small and only consists of cosmetic changes
> and one functional change for better error handling.
> 
> Changes since v3:
> * added Tested-by & Reviewed-by from Heiko
> * replaced underscores with dashes in DT property names
> * bail from of clock setup function early if of_iomap fails
> * removed unecessary explict cast
> 
> Mike Turquette (5):
>   clk: divider: replace bitfield width with mask
>   clk: of: helper for determining number of parent clocks
>   clk: dt: binding for basic multiplexer clock
>   clk: dt: binding for basic divider clock
>   clk: dt: binding for basic gate clock
> 
I have used $subject series as the base for the Keystone
ccf support and tested these patches on Keystone EVM. Will
post those patches soon on the lists.

For the series if you need more tested-by tags, feel free to
add,
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbaJXSZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:25:42 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:63935 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbaJXSZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:25:40 -0400
Message-ID: <544A99B2.8080507@gmail.com>
Date: Fri, 24 Oct 2014 11:25:54 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, khilman@linaro.org
CC: linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v3 0/5] ARM: keystone: pm: switch to use generic pm domains
References: <1414074182-25980-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1414074182-25980-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii,

On 10/23/2014 07:22 AM, Grygorii Strashko wrote:
> Hi Santosh, Kevin,
>
> This series switches Keystone 2 PM code to use Generic PM domains
> instead of PM clock domains because of the lack of DT support
> for the last.
> It will finally allow to enable Runtime PM for Keystone 2.
>
> Patch 1 was reused from [1].
>
> RFC version of patches can be found at [2].
>
> Changes in v3:
>   - handling of the case when !CONFIG_PM_RUNTIME has been
>     moved in PM clock framework.
>
> Changes in v2:
> - minor comments applied and rebased on top of Linux 3.18-rc1.
>
> Links on previous versions:
> v2:  https://lkml.org/lkml/2014/10/20/248
> v1:  https://lkml.org/lkml/2014/9/29/382
>
> [1] "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
>    https://lkml.org/lkml/2014/4/24/1118
>
> [2] "[RFC PATCH 0/4] ARM: keystone: pm: switch to use generic pm domains"
>    https://lkml.org/lkml/2014/9/25/364
>
> CC: Santosh Shilimkar <ssantosh@kernel.org>
> CC: Kevin Hilman <khilman@linaro.org>
> CC: Ulf Hansson <ulf.hansson@linaro.org>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Geert Uytterhoeven (1):
>    PM / clock_ops: Add pm_clk_add_clk()
>
> Grygorii Strashko (4):
>    PM / clock_ops: make __pm_clk_enable more generic
>    PM / clock_ops: add and enable clocks always if !CONFIG_PM_RUNTIME
>    ARM: keystone: pm: switch to use generic pm domains
>    ARM: dts: keystone: add generic pm controller node
>
You can split this series. Lets get first 3 patches sorted out as
there have been active discussion on those. Once they get direction
and merged then you can post the keystone ones which I will be
happy to merge.

Regards,
Santosh

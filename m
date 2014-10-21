Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaJUSAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:00:35 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34135 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaJUSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:00:33 -0400
Message-ID: <54469F44.4060701@gmail.com>
Date: Tue, 21 Oct 2014 11:00:36 -0700
From: Santosh Shilimkar <santosh.shilimkar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, khilman@linaro.org
CC: Geert Uytterhoeven <geert+renesas@glider.be>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        ulf.hansson@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] PM / clock_ops: Add pm_clk_add_clk()
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com> <1413809764-21995-2-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1413809764-21995-2-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin, Rafael,

On 10/20/2014 05:56 AM, Grygorii Strashko wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
>
> The existing pm_clk_add() allows to pass a clock by con_id. However,
> when referring to a specific clock from DT, no con_id is available.
>
> Add pm_clk_add_clk(), which allows to specify the struct clk * directly.
>
> Reviewed-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>
>   Pay attantion pls, that there is another series of patches
>   which have been posted already and which depends from this patch
>     "[PATCH v4 0/3] ARM: rk3288 : Add PM Domain support"
>     https://lkml.org/lkml/2014/10/20/105
>
How do you go about merging the $subject patch ?
I see there are at least 2 series which depends on this one.

Regards,
Santosh


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079AbaIBEtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:49:17 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:41476 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaIBEtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <1409597225-24368-4-git-send-email-mturquette@linaro.org>
References: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
	<1409597225-24368-4-git-send-email-mturquette@linaro.org>
Date: Tue, 2 Sep 2014 10:19:15 +0530
Message-ID: <CAKohpomf4a75G5TYr4U1VkdcRUWO-Hp6oyJPyzfOR=6-GuMBbg@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: kirkwood: use the powersave multiplexer
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2014 00:17, Mike Turquette <mturquette@linaro.org> wrote:

> @@ -150,7 +146,7 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>                 err = PTR_ERR(priv.powersave_clk);
>                 goto out_ddr;
>         }
> -       clk_prepare(priv.powersave_clk);
> +       clk_prepare_enable(priv.powersave_clk);

Shouldn't this be done in a separate patch? Or is this really related?

>
>         of_node_put(np);
>         np = NULL;

Other than that: Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Yeah, you can take it through clock tree..

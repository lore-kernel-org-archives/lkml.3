Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851Ab3HOTwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:52:36 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59990 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758553Ab3HOTwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:52:34 -0400
MIME-Version: 1.0
In-Reply-To: <e0c5392750876a08efea5db45eb13ece144fab55.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
	<e0c5392750876a08efea5db45eb13ece144fab55.1376329128.git.viresh.kumar@linaro.org>
Date: Thu, 15 Aug 2013 21:52:34 +0200
Message-ID: <CACRpkdZbTw9CstP=gWRFA=M3fENcRcXWgAnWoTCM5dYZfBxQbw@mail.gmail.com>
Subject: Re: [PATCH 09/31] cpufreq: dbx500: Covert to light weight ->target() routine
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 7:48 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> This patch converts existing .target_old() to newly defined light weight
> .target() routine for this driver.
>
> CPUFreq core will call cpufreq_frequency_table_target() before calling this
> routine and will pass index to it.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Given that the concept is accepted:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

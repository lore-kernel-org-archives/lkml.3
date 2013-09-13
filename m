Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab3IMNT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:19:26 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:63948 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627Ab3IMNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <43f3fedcc13b4cd8a016f2dbbc91936423420cb8.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<43f3fedcc13b4cd8a016f2dbbc91936423420cb8.1379063063.git.viresh.kumar@linaro.org>
Date: Fri, 13 Sep 2013 15:19:20 +0200
Message-ID: <CACRpkda=vzV1k5sJbnZSJHpEuEGwaHN_qi_-QzU79QoyoHse2w@mail.gmail.com>
Subject: Re: [PATCH 099/228] cpufreq: dbx500: don't initialize part of policy
 that is set by core too
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 3:00 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Many common initializations of struct policy are moved to core now and hence
> this driver doesn't need to do it. This patch removes such code.
>
> Most recent of those changes is to call ->get() in the core after calling
> ->init().
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

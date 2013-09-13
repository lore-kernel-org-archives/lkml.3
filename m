Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab3IMNSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:18:49 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41888 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554Ab3IMNSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <a3970f9a04fd061a7ad476f983e10a8768c89fd0.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<a3970f9a04fd061a7ad476f983e10a8768c89fd0.1379063063.git.viresh.kumar@linaro.org>
Date: Fri, 13 Sep 2013 15:18:41 +0200
Message-ID: <CACRpkdbgpuuSpHpu2-pEvOjd3hB-cqn62Ui6__VFbyNHDLu6+g@mail.gmail.com>
Subject: Re: [PATCH 063/228] cpufreq: dbx500: Use generic cpufreq routines
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

> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
> and .attr. So its better if we have generic routines for them which can be used
> by cpufreq drivers then.
>
> This patch uses these generic routines for this driver.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by. It feels like I acked this before...

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab3HNTgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:36:43 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57535 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab3HNTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:36:41 -0400
MIME-Version: 1.0
In-Reply-To: <e343e827df7be24f11ecdaf849f2874bf1ba4b24.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
	<e343e827df7be24f11ecdaf849f2874bf1ba4b24.1375964117.git.viresh.kumar@linaro.org>
Date: Wed, 14 Aug 2013 21:36:40 +0200
Message-ID: <CACRpkda29WcHePh00w_7N3B1OtGh=-i=1_PyB4MNhy=YJ-nxyg@mail.gmail.com>
Subject: Re: [PATCH 11/35] cpufreq: dbx500: use cpufreq_table_validate_and_show()
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

On Thu, Aug 8, 2013 at 3:48 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Lets use cpufreq_table_validate_and_show() instead of calling
> cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

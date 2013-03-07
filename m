Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3CGAtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:49:49 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59777 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3CGAtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:49:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=cBkHZnSa8ZsM=k7RRN+RZDXFUWDM82EXXBSQcM-8Vhw@mail.gmail.com>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
	<20130305105251.GL17833@n2100.arm.linux.org.uk>
	<CAKohpo=cBkHZnSa8ZsM=k7RRN+RZDXFUWDM82EXXBSQcM-8Vhw@mail.gmail.com>
Date: Wed, 6 Mar 2013 16:49:46 -0800
Message-ID: <CAHLZz11PR6E7-yhrxwRi=HWo9tWByH5FUArDqfXQh6N0C_x0tQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver and
 its DT glue
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, rjw@sisk.pl,
        Steve.Bannister@arm.com, linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, robin.randhawa@arm.com,
        linux-arm-kernel@lists.infradead.org, mark.hambleton@broadcom.com,
        linaro-kernel@lists.linaro.org, charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 4:32 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

>         clk[cluster] = clk_get_sys(name, NULL);
> -       if (!IS_ERR(clk[cluster])) {
> +       if (!IS_ERR_OR_NULL(clk[cluster])) {
>                 pr_debug("%s: clk: %p & freq table: %p, cluster: %d\n",
>                                 __func__, clk[cluster], freq_table[cluster],
>                                 cluster);


You seem pretty attached to IS_ERR_OR_NULL here.

Harvey

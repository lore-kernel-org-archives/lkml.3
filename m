Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab3CGBuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:50:23 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:34728 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3CGBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:50:21 -0500
MIME-Version: 1.0
X-Originating-IP: [118.143.64.134]
In-Reply-To: <20130307014657.GA7426@quad.lixom.net>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
	<20130307014657.GA7426@quad.lixom.net>
Date: Wed, 6 Mar 2013 17:50:20 -0800
Message-ID: <CAOesGMiOBxEHVgkr=K_4JVQ6+0Swy1uRmHaS8QwRxTJKs3J2Ow@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver and
 its DT glue
From: Olof Johansson <olof@lixom.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-kernel@lists.linaro.org,
        mark.hambleton@broadcom.com, linux-arm-kernel@lists.infradead.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 5:46 PM, Olof Johansson <olof@lixom.net> wrote:

> This binding makes no sense to me. It needs to be substantially better
> documented, not just a couple of sentences that people that understand
> bit.LITTLE thoroughly can make sense of.
>
> It also duplicates the cpu binding. I suspect this should instead be done
> through additions of the cpu bindings instead of duplication. So this needs to
> be substantially reworked.

Also, _ALWAYS_ cc devicetree-discuss on new bindings. get_maintainer
tells you to do so.


-Olof

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbaACFrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:47:04 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62383 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaACFrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:47:02 -0500
MIME-Version: 1.0
In-Reply-To: <52C548B6.60902@nvidia.com>
References: <1387451926-21373-1-git-send-email-bilhuang@nvidia.com>
	<CAKohpomCPJYd+d_NnM9gxwQ7bH6C6=iLxbiWZbfNcjZ8Bi+2wA@mail.gmail.com>
	<52B41B18.30302@nvidia.com>
	<CAKohpontQwTc4KP7XMvtkvS2sQTyF+ngXnXfbJ1ev+MLEp-H0g@mail.gmail.com>
	<52B41F1B.3030005@nvidia.com>
	<52B4707F.4040303@wwwdotorg.org>
	<CAKohpokwO3BgXr9Le02bNo=771saWuDe2H=fgQzcboRWxwVzOg@mail.gmail.com>
	<52C548B6.60902@nvidia.com>
Date: Fri, 3 Jan 2014 11:17:00 +0530
Message-ID: <CAKohpokQXb_w2VZStwvj-icm4KPayZgLqGZb-DYZddbj_3Dk=A@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: bilhuang <bilhuang@nvidia.com>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 January 2014 16:38, bilhuang <bilhuang@nvidia.com> wrote:
> Actually, I don't have plan or resource on doing this, would it be better
> that you help to do that instead? Thanks.

Point taken. I am there to help if required. So, initially you can just make
Tegra work according to the new file we were talking about. I will fix
others later.

>> I am not sure about the location of such file. Should this be placed in DT
>> code somewhere or kept in cpufreq? Rob/Grant ??
>>
> Do we have consensus on where to create such file?

Not yet, probably people were on leaves.

@Grant/Rob: Any inputs here?

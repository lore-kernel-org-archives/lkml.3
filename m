Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaC1IzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:55:12 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45698 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaC1IzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:55:05 -0400
MIME-Version: 1.0
In-Reply-To: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
Date: Fri, 28 Mar 2014 14:25:04 +0530
Message-ID: <CAKohponR2YZJYAeCMCpXaQ7oztGdgiG8PKNvt9sgvKQM3VCD9g@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: set value of CPUFREQ_BOOST_FREQ to 0xABABABAB
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 March 2014 12:18, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Ideally, .driver_data field of struct cpufreq_frequency_table must not be used
> by core at all. But during a recent change if its value is same as
> CPUFREQ_BOOST_FREQ macro, then it is treated specially by core.
>
> The value of this macro was set to ~2 earlier, i.e. 0xFFFFFFFD. In case some
> driver is using this field for its own data and sets this field to -3, then with
> two's complement that value will also become 0xFFFFFFFD.
>
> To fix this issue, lets change value of this flag to a very uncommon value which
> shouldn't be used by any driver unless they want to use BOOST feature.
>
> Along with this update comments to make this more clear.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Please discard this patch now as I have sent a replacement patch.

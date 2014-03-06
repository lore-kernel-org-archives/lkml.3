Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbaCFCYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:24:41 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:64867 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbaCFCYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:24:39 -0500
MIME-Version: 1.0
In-Reply-To: <1892466.Txf61ZRumM@vostro.rjw.lan>
References: <98b7ae22d936456bf830aa749556a115969cfa47.1393904428.git.viresh.kumar@linaro.org>
	<2f6efe0c9058f64212ee220a1b386e04ba415686.1393904428.git.viresh.kumar@linaro.org>
	<1892466.Txf61ZRumM@vostro.rjw.lan>
Date: Thu, 6 Mar 2014 10:24:38 +0800
Message-ID: <CAKohponJrsrFiugxALugZu3AKtD2i-Tk3NjeFM3KhXSoKgtLXg@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] cpufreq: initialize governor for a new policy
 under policy->rwsem
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2014 09:04, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I've rebased this one on top of 3.14-rc5 and queued it up for 3.14-rc6.
>
> Please check the bleeding-edge branch for the result.

Yeah, it looks fine. And I assume that you are planning to take 1/3 in 3.15?
Or going to drop it?

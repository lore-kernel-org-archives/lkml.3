Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3IREbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 00:31:16 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54790 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3IREbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 00:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=_bhaws44_XEf=DEjbVtiRfYHeMm-cK=bHo1Sed14kAg@mail.gmail.com>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
	<8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
	<52387343.7040007@wwwdotorg.org>
	<CAKohpo=_bhaws44_XEf=DEjbVtiRfYHeMm-cK=bHo1Sed14kAg@mail.gmail.com>
Date: Wed, 18 Sep 2013 10:01:13 +0530
Message-ID: <CAKohpon7PSd3Q1q8=UeRer7LY4Sgx22WLArYtK9zFj1WYgoodg@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 September 2013 21:48, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 17 September 2013 20:50, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Yes, I have asked Rafael to get this in for rc2 and few others too..
> Waiting for his reply though..

Its applied now by Rafael..

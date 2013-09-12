Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3ILGww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:52:52 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33207 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3ILGwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:52:50 -0400
MIME-Version: 1.0
In-Reply-To: <52316334.6080603@linux.vnet.ibm.com>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
	<CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com>
	<CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com>
	<5230509D.6040205@linux.vnet.ibm.com>
	<CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com>
	<CAKohpo=8mqRmmk17D52yiR9w1V4Z+2UzZ2kzABtrxHbYR+sQzw@mail.gmail.com>
	<52315E9A.3000607@linux.vnet.ibm.com>
	<CAKohpo=LuoKTf+mX1oBt97K3sJVu0iN=whN7VGw6kuartnrr+w@mail.gmail.com>
	<52316334.6080603@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:22:49 +0530
Message-ID: <CAKohponrmV4CFqicEw7tf0g47VNcVY=4mmcH1CnGX388iFYb=g@mail.gmail.com>
Subject: Re: cpufreq_stats NULL deref on second system suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 12:16, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Of course, if we change the suspend/resume sequence and that fixes this, that
> would be like getting it for free, nobody would say no to it ;-)

Not really :)

Policy with 4 CPUs, 0,1,2,3, policy->cpu currently set to 1, 2 or 3...

We will remove CPUs in order 3,2,1 and add back in 1,2,3... Or Vice Versa

policy->cpu after resume is 0 :)

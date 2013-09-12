Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3ILHSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:18:49 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49074 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3ILHSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:18:47 -0400
Message-ID: <523169E1.60304@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:44:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan>	<522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan>	<52304439.3030301@linux.vnet.ibm.com> <CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com> <CAKohpomzQ8Yzk+OU0btQM6DGm4xsY1RR9uYFrZD3ZHO-bhrwKQ@mail.gmail.com> <5230509D.6040205@linux.vnet.ibm.com> <CAKohpo=DfmNSMnyVRK0gfx7QGr=jOTbFo6uuGhEOaa2UMkeQAQ@mail.gmail.com> <CAKohpo=8mqRmmk17D52yiR9w1V4Z+2UzZ2kzABtrxHbYR+sQzw@mail.gmail.com> <52315E9A.3000607@linux.vnet.ibm.com> <CAKohpo=LuoKTf+mX1oBt97K3sJVu0iN=whN7VGw6kuartnrr+w@mail.gmail.com> <52316334.6080603@linux.vnet.ibm.com> <CAKohponrmV4CFqicEw7tf0g47VNcVY=4mmcH1CnGX388iFYb=g@mail.gmail.com>
In-Reply-To: <CAKohponrmV4CFqicEw7tf0g47VNcVY=4mmcH1CnGX388iFYb=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091207-9264-0000-0000-00000483E633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:22 PM, Viresh Kumar wrote:
> On 12 September 2013 12:16, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Of course, if we change the suspend/resume sequence and that fixes this, that
>> would be like getting it for free, nobody would say no to it ;-)
> 
> Not really :)
> 
> Policy with 4 CPUs, 0,1,2,3, policy->cpu currently set to 1, 2 or 3...
> 
> We will remove CPUs in order 3,2,1 and add back in 1,2,3... Or Vice Versa
> 
> policy->cpu after resume is 0 :)
> 

Ah, great counter-example! :-)

Regards,
Srivatsa S. Bhat


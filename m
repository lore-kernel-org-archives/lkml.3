Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3IME0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 00:26:22 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42610 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3IME0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 00:26:18 -0400
MIME-Version: 1.0
In-Reply-To: <5231F939.2010502@linux.vnet.ibm.com>
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
	<5231E3E2.1050101@wwwdotorg.org>
	<5231F939.2010502@linux.vnet.ibm.com>
Date: Fri, 13 Sep 2013 09:56:18 +0530
Message-ID: <CAKohpokEc1vZacN2X+8_cY8DF1wehSE6yaZ5-SQbqtt5qUUW_A@mail.gmail.com>
Subject: Re: cpufreq_stats NULL deref on second system suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 22:56, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/12/2013 09:25 PM, Stephen Warren wrote:
> Anyway, nevermind, as of now, subsystems do work around this suitably, so
> there is no known bug as such at the present. Just that we could have probably
> done it a better way, that's all.

Yeah, there is no bug as of now due to the number of hacks adopted by different
framework.. I believe we can still have a cleanup series to take care
of this stuff..
That would be some improvement and would be better for future.. Otherwise
this kind of problems would keep coming again and again..

> You're absolutely right! Regular CPU hotplug is more demanding than
> suspend/resume in the context we are discussing, since any CPU can be
> hotplugged at any time and put back in any order. So code like cpufreq should
> be prepared to work with any ordering.

And that part is well implemented and tested as far as I know..

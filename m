Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3IKLOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:14:19 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35329 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3IKLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:14:17 -0400
Message-ID: <52304F92.6030109@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 16:40:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan>	<522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan>	<52304439.3030301@linux.vnet.ibm.com> <CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com>
In-Reply-To: <CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091111-1396-0000-0000-0000038A4AB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 04:14 PM, Viresh Kumar wrote:
> On 11 September 2013 15:51, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 09/11/2013 04:04 AM, Rafael J. Wysocki wrote:
>>> On Tuesday, September 10, 2013 02:53:01 PM Stephen Warren wrote:
> 
>>>> Sure, it's due to 5302c3f "cpufreq: Perform light-weight init/teardown
>>>> during suspend/resume".
> 
> Sorry Stephen, I was away on vacations and came back yesterday only..
> And was badly stuck in something other CPUFreq bugs until now :)
> 
>> Sure, Rafael. Thanks for CC'ing me.
> 
> Thanks for jumping in and helping us out buddy!!!.
>

No problem :-) Besides, I am the one who broke it ;-(
 
Regards,
Srivatsa S. Bhat


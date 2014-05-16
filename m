Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaEPIsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:48:02 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59825 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaEPIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:47:59 -0400
MIME-Version: 1.0
Date: Fri, 16 May 2014 14:17:59 +0530
Message-ID: <CAKohpomarqCwU6JTpNpTOTd+4A5zwGYFYEbLFDcvAKbVyY9YTg@mail.gmail.com>
Subject: Re: [PATCH v2] PM / OPP: discard duplicate OPP additions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 14:12, Chander Kashyap <chander.kashyap@linaro.org> wrote:
> On 16 May 2014 13:54, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 16 May 2014 13:43, Chander Kashyap <chander.kashyap@linaro.org> wrote:
>>> From: Chander Kashyap <k.chander@samsung.com>
>>>
>>> It may be possible to unregister and re-register the cpufreq driver.
>>> One such example is arm big-little IKS cpufreq driver. While
>>> re-registering the driver, same OPPs may get added again.
>>>
>>> This patch detects the duplicacy and discards them.
>>
>> Diff looks fine but not the log ofcourse. It doesn't have anything to do with
>> big LITTLE.. Its just a patch to avoid addition of duplicate OPPs..
>>
>
> Big little reference is provided as an example. Nothing much

What I am saying is: "This is not a problem of re-registering drivers
but adding duplicate OPPs and that's what we should emphasize
on in the log". Your log is all focused on how to get re-registering
of a driver working.

>> Also fix spelling mistakes in log..
>>
>> And subject should be:
>> PM / OPP: discard duplicate OPPs
>
> Duplicates are discarded during OPP addition, and subject line indicates that.

I am asking to improve it. Replace:

PM / OPP: discard duplicate OPP additions

with

PM / OPP: discard duplicate OPPs

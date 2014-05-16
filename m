Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaEPImG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:42:06 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44913 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbaEPImD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:42:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=SXFYEncSe__XQHQ588hTME7cbmS+ykeWZOOt4ESb2Pg@mail.gmail.com>
References: <CAKohpo=SXFYEncSe__XQHQ588hTME7cbmS+ykeWZOOt4ESb2Pg@mail.gmail.com>
Date: Fri, 16 May 2014 14:12:02 +0530
Message-ID: <CANuQgHGPKpNYOVAgr8riULEoNr=h71OQRZLC9U193S7akM3B8g@mail.gmail.com>
Subject: Re: [PATCH v2] PM / OPP: discard duplicate OPP additions
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
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

On 16 May 2014 13:54, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 May 2014 13:43, Chander Kashyap <chander.kashyap@linaro.org> wrote:
>> From: Chander Kashyap <k.chander@samsung.com>
>>
>> It may be possible to unregister and re-register the cpufreq driver.
>> One such example is arm big-little IKS cpufreq driver. While
>> re-registering the driver, same OPPs may get added again.
>>
>> This patch detects the duplicacy and discards them.
>
> Diff looks fine but not the log ofcourse. It doesn't have anything to do with
> big LITTLE.. Its just a patch to avoid addition of duplicate OPPs..
>

Big little reference is provided as an example. Nothing much

> Also fix spelling mistakes in log..
>
> And subject should be:
> PM / OPP: discard duplicate OPPs

Duplicates are discarded during OPP addition, and subject line indicates that.

-- 
with warm regards,
Chander Kashyap

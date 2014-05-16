Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaEPIYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:24:10 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54028 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656AbaEPIYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:24:04 -0400
MIME-Version: 1.0
Date: Fri, 16 May 2014 13:54:03 +0530
Message-ID: <CAKohpo=SXFYEncSe__XQHQ588hTME7cbmS+ykeWZOOt4ESb2Pg@mail.gmail.com>
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

On 16 May 2014 13:43, Chander Kashyap <chander.kashyap@linaro.org> wrote:
> From: Chander Kashyap <k.chander@samsung.com>
>
> It may be possible to unregister and re-register the cpufreq driver.
> One such example is arm big-little IKS cpufreq driver. While
> re-registering the driver, same OPPs may get added again.
>
> This patch detects the duplicacy and discards them.

Diff looks fine but not the log ofcourse. It doesn't have anything to do with
big LITTLE.. Its just a patch to avoid addition of duplicate OPPs..

Also fix spelling mistakes in log..

And subject should be:
PM / OPP: discard duplicate OPPs

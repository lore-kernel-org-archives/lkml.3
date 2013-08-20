Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab3HTMhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:37:18 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46506 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3HTMhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <4207583.84U9qMI9uv@vostro.rjw.lan>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
	<4207583.84U9qMI9uv@vostro.rjw.lan>
Date: Tue, 20 Aug 2013 18:07:14 +0530
Message-ID: <CAKohpomCaUvns+45qV-MdcxmRJ9fihdDf--BgH5uxEFqVnFPHQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] cpufreq: Fixes for 3.12
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 August 2013 18:13, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, this looks good, but do we really need it in 3.12?  It doesn't look
> like 3.12 will be missing these changes a lot?

Hmm.. If its too late for 3.12 we can skip them, but first two are bug
fixes really (though nobody is affected as cpufreq_policy_list isn't used
yet :) ) and other three are cleanups..

So, if there is any chance that we can queue them up for 3.12, it would
be good.. but definitely not a must to have stuff. :)

--
viresh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab3L0J61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:58:27 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54489 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab3L0J6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:58:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpom9_-9bDJ9tWDHmm1inMporaHytAvmrgfPSs2koRqGzBw@mail.gmail.com>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan>
	<CAKohponHBaGG1e5e+Wmg6rqMB-nbRx1e=F+u5AoaNb=mxfQL6A@mail.gmail.com>
	<CAKohpom9_-9bDJ9tWDHmm1inMporaHytAvmrgfPSs2koRqGzBw@mail.gmail.com>
Date: Fri, 27 Dec 2013 15:28:24 +0530
Message-ID: <CAKohpokW2FCN33VZOSUQ0xbgt6FgxtfQyPZintGL9URDHH8LCQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 December 2013 15:27, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> I think there is nothing much different in this patch compared to what Bjorn
> tested. So you can probably push that now and let him test linux-next later
> once he is back?

Just saw that you already pushed it. :)

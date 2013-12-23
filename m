Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3LWKpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 05:45:09 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49765 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab3LWKpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 05:45:07 -0500
MIME-Version: 1.0
In-Reply-To: <877gavgbuv.fsf@nemi.mork.no>
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>
	<1651441.C2UQleWVoy@vostro.rjw.lan>
	<871u14i00j.fsf@nemi.mork.no>
	<CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com>
	<87d2kokqdl.fsf@nemi.mork.no>
	<52B7EC81.6060202@linaro.org>
	<877gavgbuv.fsf@nemi.mork.no>
Date: Mon, 23 Dec 2013 16:15:06 +0530
Message-ID: <CAKohpo=0HRihdTiQLk+mKiarUdXOPO3n7GCJ9CUoi=4xJ_AYcg@mail.gmail.com>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed
 to come back after resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 December 2013 14:53, Bjørn Mork <bjorn@mork.no> wrote:
> Confirmed.  With that patch on top of the current pm-cpufreq branch all
> functionality is restored and there are no regressions AFAICS.

Thanks..

> I still don't understand why you want to add this hackish half-assed
> suspend implementation

As it is working currently, until we have a proper solution which I am
already discussing with Rafael:

https://lkml.org/lkml/2013/11/22/66

> But if you really want to implement suspend/resume, then you
> do need to keep the whole device and not just the sysfs files. Keeping
> the attribute files allow you to save and restore changed permissions,
> but it doesn't save any user modified settings.

Which settings are you talking about? I thought we are preserving all
files..

> Well, not my problem...  Just wondering really.

:)

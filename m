Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab3IPE1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:27:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33949 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3IPE11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:27:27 -0400
MIME-Version: 1.0
In-Reply-To: <32077984.uYNhUh2ogt@vostro.rjw.lan>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<52339729.7030309@wwwdotorg.org>
	<CAKohpono-J-Ohzdn=pbNK+HhXhJ2Lf-UBM7OPynTgAwxLd4F4A@mail.gmail.com>
	<32077984.uYNhUh2ogt@vostro.rjw.lan>
Date: Mon, 16 Sep 2013 09:57:27 +0530
Message-ID: <CAKohponrJerykspkd0b4wtE2YtPRMpphUW_3ZN0Lg9Q6bNdJRg@mail.gmail.com>
Subject: Re: [PATCH 211/228] cpufreq: tegra: remove calls to cpufreq_notify_transition()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 September 2013 10:35, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, I guess you can assume that everyone has a chance to review the series
> by now and send it as one patch in the next iteration.

Yeah, that's what I thought..

> A patch that adds 192 lines of code isn't shockingly large by any measure.

It was more about removal of things and the number of files it touches..
But yes, its good for review to send them separately but in the end they can
be merged..

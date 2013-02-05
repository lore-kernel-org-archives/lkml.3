Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3BEJ6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:58:37 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:39031 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3BEJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <3480441.gCEh0J5edK@vostro.rjw.lan>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
	<2765418.Ft0GYkgNgL@vostro.rjw.lan>
	<CAOh2x=n+ASeLpGHexxDvPGrN6ia+bLnNUNCb-covGDoABVk_wQ@mail.gmail.com>
	<3480441.gCEh0J5edK@vostro.rjw.lan>
Date: Tue, 5 Feb 2013 15:28:30 +0530
X-Google-Sender-Auth: sGZIKHr9LTPVApRpWRECq1mrBwM
Message-ID: <CAOh2x=mWc9rBX3O_1NSr23TAWFtRA6BNW3TZ8FhZOMdH_0dmzQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 3:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> I actually don't agree with that, becuase the Nathan's apprach shows the
> reasoning that leads to the RCU introduction quite clearly.  So if you
> don't have technical problems with the patchset, I'm going to take it as is.

Great!!

Okay.. I don't have any technical problems with it, i reviewed most of it
carefully. The only pending thing is rebase on linux-next, after that i can
give my ack for it.

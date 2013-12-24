Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3LXA1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:27:37 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40121 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3LXA1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:27:35 -0500
MIME-Version: 1.0
In-Reply-To: <1614824.4yERnS53EQ@vostro.rjw.lan>
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>
	<87pponx07s.fsf@nemi.mork.no>
	<52B85AA4.6070609@linaro.org>
	<1614824.4yERnS53EQ@vostro.rjw.lan>
Date: Tue, 24 Dec 2013 05:57:35 +0530
Message-ID: <CAKohpokHajZ0OudZp1Tb-a-Q70-4OuLDGV9SR==yX1K9P0rDgA@mail.gmail.com>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed
 to come back after resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2013 06:05, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> OK
>
> Can you please combine this with the patch you sent previously (if that one
> is still necessary) and resubmit with a new subject?

Yes both are required and I really want two separate patches here as they
potentially target separate problems.

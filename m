Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaHLEkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 00:40:23 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:51491 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaHLEkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 00:40:21 -0400
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 10:10:20 +0530
Message-ID: <CAKohpo=vFd7BN07DfasZGBQWPAjFyKRAQsQTOtjLQ4QebzMzGA@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] cpufreq: Don't wait for CPU to going offline to
 restart governor
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2014 03:41, Saravana Kannan <skannan@codeaurora.org> wrote:

> Suggestions welcome. I think the current one explains the main point of this change.

Atleast we need a s/going/go

>> There is a down_read() present early in this routine and we better update this
>> at that place only.
>
>
> I would rather not. My v1 patch series was super refactored to allow a lot of reuse, etc. But you guys complained about the diffs being confusing (which was a valid point).
>
> Also, if we are talking about refactoring this, there's room for much better refactor at the end of the series. I will add a patch to the series to do the refactoring.

The kind of change I am suggesting you can be done in the original
patch only. What we told you in the earlier reviews was to break patches
into meaningful sections instead of doing everything in a single patch.

> That only runs if cpu != policy->cpu. This needs to run irrespective of that.

Oh yes, correct.

> You mean the log in the cover letter? Will do.

Coverletter isn't the right place for mentioning such important things
as it never gets commited. I was talking about the commit log.

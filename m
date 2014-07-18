Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbaGRETE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:19:04 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:61532 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217AbaGRETC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <53C8938F.1070706@codeaurora.org>
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
	<1405464473-3916-2-git-send-email-skannan@codeaurora.org>
	<CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
	<53C65F03.1050609@mit.edu>
	<53C6D8EC.1030609@codeaurora.org>
	<CAKohpongsNtEVbHL=w1fbw5tEXK=WaMcp1N03ar9Sx_CU=1O-w@mail.gmail.com>
	<53C8938F.1070706@codeaurora.org>
Date: Fri, 18 Jul 2014 09:49:01 +0530
Message-ID: <CAKohpo=puU-AifGAXMAOs1pnyvTk64u-Fkra5i=-QNn_a-isXQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Srivatsa S. Bhat" <srivatsa@mit.edu>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
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

On 18 July 2014 08:55, Saravana Kannan <skannan@codeaurora.org> wrote:
> Not really. We much never do it during hotplug. We only do it when the
> cpufreq driver unregisters.

Oh yes.

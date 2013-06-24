Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3FXKdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:33:17 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61957 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3FXKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:33:15 -0400
MIME-Version: 1.0
In-Reply-To: <3966081.PYqoVoQ0Wq@vostro.rjw.lan>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
	<24083337.GLRAoa2hpo@vostro.rjw.lan>
	<CAKohpo=q+2ULzOSeipjb8xS6NZBJLbR8AMptVcufD1vzULJGGw@mail.gmail.com>
	<3966081.PYqoVoQ0Wq@vostro.rjw.lan>
Date: Mon, 24 Jun 2013 16:03:15 +0530
Message-ID: <CAKohponJ7WZ9pc20653gj_bPEAC_ZCA43XgZVPmNBcBs7pLFAQ@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2013 15:50, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> My impression was that that new interface wouldn't be useful on all platforms
> supported by cpufreq.  If that's the case, I'd rather not make changes in the
> core code that are needed only to implement that new interface, at least to
> start with.

Every platform might not have userspace software that would do some
actions based on this. But, these are nice and useful stats to have.

They tell you a lot about how the hardware/governor/policies are
behaving with load. And so will eventually help getting performance based
on governor tunables for your platform. That's why I asked to put this in
core as this should be pretty much useful.

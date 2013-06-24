Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FXJaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:30:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48845 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3FXJaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:30:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show accumulated data of CPUs
Date: Mon, 24 Jun 2013 11:39:30 +0200
Message-ID: <24083337.GLRAoa2hpo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponvcqJvU1KKkK0EymcLjjLsC9_=z1oSDsKbJdyWf8SB9Q@mail.gmail.com>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com> <5527616.jZ71Fx7IV6@vostro.rjw.lan> <CAKohponvcqJvU1KKkK0EymcLjjLsC9_=z1oSDsKbJdyWf8SB9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 11:48:22 AM Viresh Kumar wrote:
> On 21 June 2013 18:43, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Well, to be honest, I don't like the whole thing.  The more changes you need
> > to make to the common code to support it, the worse.
> 
> You meant you didn't like this patch completely? Or the idea that
> I gave?

Well, kind of both ...

> Getting the new frequency would be very useful IMHO. That would
> give us a relation between old/new freq and load on each cpu at
> that time. That's why I suggested it.

Where "us" is user space or what?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

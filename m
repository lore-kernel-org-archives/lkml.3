Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3FXGSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:18:24 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:63835 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3FXGSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <5527616.jZ71Fx7IV6@vostro.rjw.lan>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
	<CAKohpo=0m8+WegUmMR2BOKeY2mJZw=X5-nEAp26M5L3PH9Bz2A@mail.gmail.com>
	<51C3D01F.7040907@samsung.com>
	<5527616.jZ71Fx7IV6@vostro.rjw.lan>
Date: Mon, 24 Jun 2013 11:48:22 +0530
Message-ID: <CAKohponvcqJvU1KKkK0EymcLjjLsC9_=z1oSDsKbJdyWf8SB9Q@mail.gmail.com>
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

On 21 June 2013 18:43, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, to be honest, I don't like the whole thing.  The more changes you need
> to make to the common code to support it, the worse.

You meant you didn't like this patch completely? Or the idea that
I gave?

Getting the new frequency would be very useful IMHO. That would
give us a relation between old/new freq and load on each cpu at
that time. That's why I suggested it.

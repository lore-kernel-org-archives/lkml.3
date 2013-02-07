Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3BGKaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:30:22 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36990 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3BGKaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:30:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130206202513.GA5626@thinkpad.lan>
References: <20130206202513.GA5626@thinkpad.lan>
Date: Thu, 7 Feb 2013 16:00:17 +0530
X-Google-Sender-Auth: kHI1oYXW9t8Zvn3sbJVbfEms86k
Message-ID: <CAOh2x=kVQ0JOgY7-1UTiz4nwSHkngQ74A0pF8TPDgqaciZnR5g@mail.gmail.com>
Subject: Re: [BUG] cpufreq: sleeping function called from invalid context at kernel/workqueue.c:2811
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 1:55 AM, Artem Savkov <artem.savkov@gmail.com> wrote:
> I get the following BUG on suspend using systemd-sleep(this doesn't
> happen with pm-suspend). This seems to be introduced by some of the
> Viresh's patches.

Hi Artem,

I have sent another patchset (and you are in --to), please test your platform
with these and tell us the results.

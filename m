Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbaHMEc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:32:28 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40945 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaHMEc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 00:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <3606476.mQLS7miLfb@spock>
References: <4708675.eITUXPv8Ih@spock>
	<CAOh2x=nJTuKKKyM72MUFSkrsH1eh1YgRUbfLcTCpfZzO85q80w@mail.gmail.com>
	<1449757.YVvGmvgCpE@spock>
	<3606476.mQLS7miLfb@spock>
Date: Wed, 13 Aug 2014 10:02:26 +0530
Message-ID: <CAKohpomF9QLLG-6evXWeUvrR9k7Y8ypVNdXyE4cAi=EFOQviHQ@mail.gmail.com>
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2014 23:48, Oleksandr Natalenko <oleksandr@natalenko.name> wrote:
> Hmm, looks like I've put pr_info to policy notifier instead of transition
> notifier. Will fix it now and post new logs.

That's why you should have copied the diff here, so that I could have
confirmed if what you have done is correct or not.

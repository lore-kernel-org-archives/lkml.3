Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750786Ab3BEHEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:04:02 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37797 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3BEHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:03:59 -0500
MIME-Version: 1.0
In-Reply-To: <510FFD2C.90902@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
	<1359744343-18690-9-git-send-email-dirk.brandewie@gmail.com>
	<CAOh2x=mU8+mJmr=BXjSLaz7Yxg--t2mPpsc_=Xry2ArNroB8Aw@mail.gmail.com>
	<510FFD2C.90902@gmail.com>
Date: Tue, 5 Feb 2013 12:33:58 +0530
Message-ID: <CAKohpokWOEDS9BeKgH8NapdBDxhxg0f0CMYHsLvACg4woTvmew@mail.gmail.com>
Subject: Re: [PATCH 5/6] cpufreq: balance out cpufreq_cpu_{get,put} for
 scaling drivers using setpolicy
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 23:55, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> Hi Viresh,
>
> I have rebased onto bleeding-edge when I reboot the system I get a kernel
> panic.
> Any idea what I could have done that would have broken the restructured
> cpufreq_{add/remove}_dev.

Dirk, there are two mail chains for similar issue. Lets discuss these
issues in the
other thread: "BUG in bleeding edge c560f3d".

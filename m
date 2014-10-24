Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbaJXS1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:27:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63891 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004AbaJXS1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:27:30 -0400
MIME-Version: 1.0
Date: Fri, 24 Oct 2014 14:27:28 -0400
Message-ID: <CAAQ0mPiq_n8RCf5h101UyPcA+kFChhXLn2C3aCxNvD5juY=_BA@mail.gmail.com>
Subject: CPU time not showing up in /proc/stat (or top)
From: Martin Martin <martin@infinio.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a virtual machine that's using ip_tables to set up some
connection forwarding. According to top, sar and /proc/stat, I'm > 99%
idle. However, perf says I'm only about 72% idle, with the rest all
accounted for by swapper in __do_softirq and various network related
functions, most involving VMXnet 3, since that's the network driver
I'm using.

VMware's own performance monitoring roughly corresponds to what perf
is saying: about 25% of cpu being used.

Is there some way to monitor the actual amount of CPU being used, that
includes time spent in network drivers, servicing soft irqs and all
like that?

If there's a better mailing list for this topic, I'm sorry for the
noise and please let me know where I should post my question.

Thanks,
Martin

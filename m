Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3FKVvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:51:35 -0400
Received: from www.sr71.net ([198.145.64.142]:46731 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534Ab3FKVve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:51:34 -0400
Message-ID: <51B79BE5.80804@sr71.net>
Date: Tue, 11 Jun 2013 14:51:33 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        rjw@sisk.pl
Subject: cpu hotplug:  possible_cpus broken (again?) next-20130607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

possible_cpus looks broken again.  I'm booting with:

 maxcpus=10 possible_cpus=160

But I only get 0-9 in sysfs:

> # ls /sys/devices/system/cpu/
> cpu0  cpu2  cpu4  cpu6  cpu8  cpufreq  kernel_max  offline  possible  probe    uevent
> cpu1  cpu3  cpu5  cpu7  cpu9  cpuidle  modalias    online   present   release




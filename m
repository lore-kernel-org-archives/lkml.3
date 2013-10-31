Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3JaF3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:29:25 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49644 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3JaF3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:29:24 -0400
Message-ID: <5271EAAC.7080304@gmail.com>
Date: Thu, 31 Oct 2013 13:29:16 +0800
From: Younger Liu <younger.liucn@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: kernel <linux-kernel@vger.kernel.org>
Subject: Question: Takes about 2s in sched_clock_init() when kernel boots
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  When I analyse boot time on ArmV7, I found that it takes
about 2s in sched_clock_init(), the log is as follow:
[    0.000000] before:sched_clock_init.
[    0.000000] start:sched_clock_init.
[    2.100505] end  :sched_clock_init.
[    2.103983] before:calibrate_delay.

  In my config, CONFIG_HAVE_UNSTABLE_SCHED_CLOCK does not config.

  Are there any suggestions?

	Younger

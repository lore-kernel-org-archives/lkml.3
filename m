Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3JLNrC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 09:47:02 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:33877 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3JLNrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 09:47:00 -0400
MIME-Version: 1.0
Date: Sat, 12 Oct 2013 19:16:59 +0530
Message-ID: <CANMsd01xcG33noC4VEDPPcU9g+L1GTN5J=A-XTOS9_vPEq2a0A@mail.gmail.com>
Subject: smp questions
From: Ryan <ryanphilips19@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

I use a custom kernel for ARM Cortex A9. When i enable the following
macros. it detects 2 cores

CONFIG_CACHE_L2X0=y
CONFIG_CACHE_PL310_INSN_PREFETCH=y
CONFIG_CACHE_PL310_DATA_PREFETCH=y
CONFIG_CACHE_PL310_PREFETCH_DOUBLE_LINEFILL=y
CONFIG_CACHE_PL310_PREFETCH_DROP=y
CONFIG_CACHE_PL310_STANDBY_MODE=y
CONFIG_CACHE_PL310_DYNAMIC_CLOCK_GATING=y

However, If i disable them it detects only One Core.

Any Idea why is this required?


Regards,
Ryan

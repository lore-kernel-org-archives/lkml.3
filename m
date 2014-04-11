Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbaDKN5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:57:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298AbaDKNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:54 -0400
Message-Id: <20140411134243.160989490@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while ago both Mike and Andy complained that we still get pointless wakeup
IPIs, we had a few patches back and forth but eventually more or less agreed
and then nothing... :-)

So here's a number of patches that implement something near what we left off
with.

Its only been compile/boot tested on x86_64, I've no actually looked at the IPI
numbers yet.


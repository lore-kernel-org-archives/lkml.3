Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966147AbaFSVwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:52:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:55818 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbaFSVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:52:25 -0400
Message-Id: <20140619214858.755664030@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:52:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, spear-devel@list.st.com
Subject: [patch 0/2] clk: spear3xx: Make it actually work
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is broken since commit 5df33a62c (SPEAr: Switch to common
clock framework). Sigh...

The first patch fixes that issue and the second one makes the uarts1/2
usable. 

Quality stuff that.

Thanks,

	tglx





Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaGMOMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:12:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55899 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaGMOMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:12:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thomas Gleixner <tglx@linutronix.de>,
        "LKML" <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140619214858.755664030@linutronix.de>
Cc: "Viresh Kumar" <viresh.linux@gmail.com>, spear-devel@list.st.com
References: <20140619214858.755664030@linutronix.de>
Message-ID: <20140713141242.9850.58515@quantum>
User-Agent: alot/0.3.5
Subject: Re: [patch 0/2] clk: spear3xx: Make it actually work
Date: Sun, 13 Jul 2014 07:12:42 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thomas Gleixner (2014-06-19 14:52:23)
> This code is broken since commit 5df33a62c (SPEAr: Switch to common
> clock framework). Sigh...
> 
> The first patch fixes that issue and the second one makes the uarts1/2
> usable. 

Applied to clk-fixes.

Regards,
Mike

> 
> Quality stuff that.
> 
> Thanks,
> 
>         tglx
> 
> 
> 
> 

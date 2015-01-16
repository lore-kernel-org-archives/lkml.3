Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbbAPTFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:05:48 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:62587 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbbAPTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <1421427439-11699-2-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1421427439-11699-2-git-send-email-alexandre.belloni@free-electrons.com>
Date: Fri, 16 Jan 2015 11:05:46 -0800
Message-ID: <CALAqxLUwRirmeZD-ggbq0ryTi4vrT5w3Drfzg3zLxXnmrurOJg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] clocksource: track usage
From: John Stultz <john.stultz@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 8:57 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Track whether the clocksource is enabled or disabled.


So.. this commit message needs work. Why do we care to track the
clocksource enabled/disabled state?

thanks
-john

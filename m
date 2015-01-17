Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbbAQB0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:26:38 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38330 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751122AbbAQB0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:26:37 -0500
Date: Sat, 17 Jan 2015 02:26:25 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] clocksource: track usage
Message-ID: <20150117012625.GU3843@piout.net>
References: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421427439-11699-2-git-send-email-alexandre.belloni@free-electrons.com>
 <CALAqxLUwRirmeZD-ggbq0ryTi4vrT5w3Drfzg3zLxXnmrurOJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUwRirmeZD-ggbq0ryTi4vrT5w3Drfzg3zLxXnmrurOJg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16/01/2015 at 11:05:46 -0800, John Stultz wrote :
> On Fri, Jan 16, 2015 at 8:57 AM, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
> > Track whether the clocksource is enabled or disabled.
> 
> 
> So.. this commit message needs work. Why do we care to track the
> clocksource enabled/disabled state?
> 

What about:

Track whether the clocksource is enabled or disabled. This will allow to
select whether an action is necessary, for example suspend or resume.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

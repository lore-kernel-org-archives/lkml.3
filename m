Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaF1Syv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:54:51 -0400
Received: from mout.gmx.net ([212.227.17.20]:60820 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbaF1Sys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 14:54:48 -0400
Date: Sat, 28 Jun 2014 20:54:33 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Whitmore <arigead@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 0/2][RFC] Try to handle hctosys w/ rtc modules
Message-Id: <20140628205433.0ef4a8cf28a7fe4861a733dd@gmx.de>
In-Reply-To: <53AE6FA2.7000808@ahsoftware.de>
References: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
	<53AE6C3C.5090308@ahsoftware.de>
	<53AE6FA2.7000808@ahsoftware.de>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Jp/Jv2rTR3qqfV20/egnlUJCTLYAaUfk/x6ieaHITu2WvTeyq5Z
 3lfHZ7z1LzhLHIy89XMEBMqbQZfn22cta5Agi5AgiigCOfEWWw0Ac4pVJc9Y2NLYqpHzE8C
 XTt0r9epfUyv4qFjzGnmJ9tm9QtnOPa0n7oDc2aixdWW/WAE2hESOxTki+IoJZA8RL5Cj2e
 l/4pehc8U9VvR+0UyynXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 09:32:50 +0200
Alexander Holler <holler@ahsoftware.de> wrote:

> Am 28.06.2014 09:18, schrieb Alexander Holler:
> > Am 27.06.2014 19:27, schrieb John Stultz:
> >> Its been pointed out that the RTC hctosys functionality doesn't
> >> work well with RTC modules, which may not be loaded until after
> >> late_init().
> >>
> >> While there have been other attempts to sovle this, this patchset
> >> is a very quick 10 minute effort to show how I'd try to resolve
> >> this. There likely are still issues here, but I'd be happy to
> >> make fixes and adjustments to ensure it works.
> 
> How long you needed to getthe idea?
> 
> >>
> >> Feedback and comments always appreciated!
> >
> > And it still uses the non-deterministic and therefor almost unusable
> > rtcN. Well done.
> 
> Besides that the current hctosys-mechanism doesn't really work with 
> hot-plugable devices at all. Guess what N will be when you unplug and 
> plug in such a RTC again.

We have a patch in the kernel which binds the rtc number to the
hw device, so this even works for hotpluggable devices (at least on
systems supporting device-tree). Not sure what your needs are.

Marc


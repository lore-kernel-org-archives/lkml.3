Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBVKAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 05:00:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:45909 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaBVKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 05:00:53 -0500
Date: Sat, 22 Feb 2014 11:01:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] [RFC] time: Improve negative offset handling in
 timekeeping_inject_offset
In-Reply-To: <CALAqxLUJYT9G2ekEk_BoNNL4T6Pjiq56KR_i87GLnSuyddWS0Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402221058010.21251@ionos.tec.linutronix.de>
References: <1393019430-13200-1-git-send-email-john.stultz@linaro.org> <alpine.DEB.2.02.1402212255590.21251@ionos.tec.linutronix.de> <CALAqxLUJYT9G2ekEk_BoNNL4T6Pjiq56KR_i87GLnSuyddWS0Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, John Stultz wrote:
> But yes, we can just leave it as is, and it is a bit academic. But

To be honest, I was mostly arguing due to the academic nature. :)

The important point is that we restrict it to -1e9 < tv_nsec <
1e9. The signed/unsigned combos are not that interesting as long as
our internal helpers cope nicely with that.

Thanks,

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaICK7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:59:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:43463 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbaICK7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:59:53 -0400
Date: Wed, 3 Sep 2014 12:59:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
 calculation.
In-Reply-To: <1409031951-39021-5-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.10.1409031257520.3333@nanos>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com> <1409031951-39021-5-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Xiubo Li wrote:

> We should minus one after calculating the counter input clock's
> prescaler.

And that's a complete useless changelog.

A) It lacks a proper description of the problem

B) It lacks a proper argument WHY we must decrement the prescaler
   value

   Hint: I used the verb "must" instead of "should". Can you figure
   out why?

Thanks,

	tglx

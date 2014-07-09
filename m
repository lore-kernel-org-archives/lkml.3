Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaGIR6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:58:38 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33549 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686AbaGIR6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:58:35 -0400
Date: Wed, 9 Jul 2014 19:58:25 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-serial@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC v3] 8250-core based serial driver for OMAP
Message-ID: <20140709175825.GA26622@breakpoint.cc>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Subject
On 2014-07-09 19:49:31 [+0200], Sebastian Andrzej Siewior wrote:
> This is version three of the patch set. Unless something serious comes up
> I would drop the RFC on the next post.
> 
> So far I should have everything covered up comparing to the omap-serial
> driver except for the throttle callbacks. And now I would slowly start
> looking into DMA support…
> 
Sebastian

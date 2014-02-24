Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaBXAcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:32:06 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:65033 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaBXAcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:32:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140223212736.664624945@linutronix.de>
References: <20140223212703.511977310@linutronix.de>
	<20140223212736.664624945@linutronix.de>
Date: Mon, 24 Feb 2014 04:32:03 +0400
Message-ID: <CAMo8BfKWJuoVUWB7reqa2AGLuEbS8_9YFoctof_M1V59g8J6gw@mail.gmail.com>
Subject: Re: [patch 04/26] xtensa: Use irq_set_affinity instead of homebrewn code
From: Max Filippov <jcmvbkbc@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Chris Zankel <chris@zankel.net>,
        xtensa <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 1:40 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> There is no point in having an incomplete copy of irq_set_affinity()
> for the hotplug irq migration code.
>
> Use the core function instead and while at it switch to
> for_each_active_irq()
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: xtensa <linux-xtensa@linux-xtensa.org>
> ---
>  arch/xtensa/kernel/irq.c |   20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max

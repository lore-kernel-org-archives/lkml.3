Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3BCKWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 05:22:54 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:58031 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3BCKWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 05:22:52 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Anatolij Gustschin <agust@denx.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: mpc8xxx: don't set IRQ_TYPE_NONE when creating irq mapping
References: <1359461275-7059-1-git-send-email-agust@denx.de>
	<CACRpkdYuSpLPnTV4bNnLnA64fix7HjCU2tP6NpDn7zo+HhQ4Wg@mail.gmail.com>
	<20130202202952.378af5cb@crub>
Date: Sun, 03 Feb 2013 11:22:45 +0100
In-Reply-To: <20130202202952.378af5cb@crub> (Anatolij Gustschin's message of
	"Sat, 2 Feb 2013 20:29:52 +0100")
Message-ID: <87r4kx66iy.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Anatolij" == Anatolij Gustschin <agust@denx.de> writes:

Hi,

 Anatolij> Thomas renamed the old set_irq_type() call to
 Anatolij> irq_set_irq_type(), but this line setting the IRQ_TYPE_NONE
 Anatolij> type was there before renaming.  It was added by commit
 Anatolij> 345e5c8a. At this time set_irq_type() checked its type
 Anatolij> argument and returned 0 if the type argument didn't specify
 Anatolij> some meaningful type in its type sense bits (and thus was
 Anatolij> equal to IRQ_TYPE_NONE). Effectively this line was a nop and
 Anatolij> I wonder what was the point of adding it.

Sorry, don't recall. It's been quite a while, and I've haven't worked on
anything mpc8xxx for a few years by now. Most likely one of the other
gpio drivers did it like this back then.

I don't remember the details, but your description makes sense so if
nobody disagrees you can have my:

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaF3JmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:42:06 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46948 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752372AbaF3JmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:42:04 -0400
Date: Mon, 30 Jun 2014 10:41:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: ulli.kroll@googlemail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes gemmi_idle in file idle.c
Message-ID: <20140630094157.GT32514@n2100.arm.linux.org.uk>
References: <1404096760-5239-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404096760-5239-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 10:52:40PM -0400, Nicholas Krause wrote:
> disables the IRQ line in gemmi_idle before calling cpu_do_idle.
> In addition, according to the Fixme message in this file fixes
> races that may occur due to not disabling the IRQ before calling
> cpu_do_idle.

1) the idle method is called with interrupts already disabled.
2) I wonder if you read the comment above the comment you removed, and
   if so, why it wasn't removed.
3) can you indicate how the hardware problem has been fixed, or give some
   justification why this change should be accepted.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

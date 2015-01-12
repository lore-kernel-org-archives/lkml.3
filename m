Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbbALUqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:46:01 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45089 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbbALUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:45:59 -0500
Date: Mon, 12 Jan 2015 21:45:53 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 00/10][RFC] Increased clocksource validation and cleanups
Message-ID: <20150112204553.GD4233@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
 <20150111114124.GD4467@localhost.localdomain>
 <CALAqxLW7xymopptsq5zWMyY_P25WmNvKne4u_LH-kZKK25N5fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLW7xymopptsq5zWMyY_P25WmNvKne4u_LH-kZKK25N5fQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:22:11AM -0800, John Stultz wrote:
> Yea, I've not looked at the actual performance impact yet, but things
> like the read-time capping (which is in the hot path) could be put
> under a debug config. Thanks for the suggestion!

Having a broken clock is like having a broken memory card.  Both will
make your system behave very strangely.  Once you start having really
strange issues, you run a dedicated memory test.  That is why I would
expect to have clock validation as compile time option.

Thanks,
Richard

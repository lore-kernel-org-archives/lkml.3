Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaC1Vrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:47:31 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41954 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753290AbaC1Vr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:47:28 -0400
Date: Fri, 28 Mar 2014 21:47:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alex Elder <elder@linaro.org>
Cc: linus.walleij@linaro.org, viresh.linux@gmail.com, shiraz.hashim@gmail.com,
        catalin.marinas@arm.com, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] ARM: SMP: common "pen" secondary release method
Message-ID: <20140328214703.GV7528@n2100.arm.linux.org.uk>
References: <1396041180-29897-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396041180-29897-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 04:12:53PM -0500, Alex Elder wrote:
> This series proposes creating a single implementation of the "pen
> release" (or spin-table) mechanism for starting secondary CPUs on
> ARM SMP systems.  This mechanism is currently implemented at least 5
> times in the kernel, each essentially identical to the other.  There
> are other machines that use this method, but slight differences make
> it necessary to incorporate further work in order to accomodate them
> with a single set of functions.

As I've already said, I have strong objections against anything which
"officialises" this holding-pen approach to secondary CPUs and encourages
it's cargo cult programming with respect to it.  I've already made my
views abundantly clear on this subject many times, and they haven't
changed.  I've indicated some clear technical reasons why it should
not be encouraged.

By moving this crap it into core code, you're giving it a stronger
endorsement that it's a right way to deal with bringing CPUs online.
It isn't.  It must not be encouraged.

> This work began with integrating SMP support for a Broadcom SoC.
> The code I started was another copy of the "pen release" code.

... which just goes to show how people cargo-cult program all the
time - and don't really have a clue what the hell they're doing.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

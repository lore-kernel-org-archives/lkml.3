Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3BAEAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:00:55 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:57708 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3BAEAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:00:54 -0500
Date: Thu, 31 Jan 2013 23:00:51 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org, Will Deacon <will.deacon@arm.com>,
        paulmck@linux.vnet.ibm.com, Catalin Marinas <catalin.marinas@arm.com>,
        marc.zyngier@arm.com, linus.walleij@linaro.org
Subject: Re: [PATCH v4 00/13] ARM LPAE Fixes - Part 1
In-Reply-To: <1359669512-31276-1-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1301312252230.6300@xanadu.home>
References: <1359669512-31276-1-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Cyril Chemparathy wrote:

> This series is a repost of the LPAE related changes in preparation for the
> introduction of the Keystone sub-architecture.  The original series has now
> been split, and this particular series excludes the earlier changes to the
> runtime code patching implementation.  Earlier versions of this series can be
> found at [1], [2], [3] and [4].
> 
> These patches are also available in git:
> git://git.kernel.org/pub/scm/linux/kernel/git/cchemparathy/linux-keystone.git upstream/keystone-lpae-v4

This part 1 looks very nice.  It received many review cycles already as 
well.  It would be about time it goes upstream.

I think it is ready to be merged in Russell's tree.  Feel free to send 
him a pull request whenever you're ready.

Then we'll be free to look at the more controvertial p2v patching stuff.


Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaJOCIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:08:13 -0400
Received: from ozlabs.org ([103.22.144.67]:53026 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbaJOCIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:08:12 -0400
In-Reply-To: <1412919926-13123-1-git-send-email-vvijayan@mvista.com>
To: Vineeth Vijayan <vvijayan@mvista.com>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: Vineeth Vijayan <vvijayan@mvista.com>
Subject: Re: powerpc: Fix Text randomization
Message-Id: <20141015020811.7904E14011B@ozlabs.org>
Date: Wed, 15 Oct 2014 13:08:11 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 05:45:26 UTC, Vineeth Vijayan wrote:
> Right now there is no way to disable TEXT randomization on a PPC32
> machine. text randomization happens even in the case of "echo 0 >
> /proc/sys/kernel/randomize_va_space"

Yeah it seems to happen on ppc64 too.

> This happens due to the incorrect definition of ELF_ET_DYN_BASE at
> arch/powerpc/include/asm/elf.h

What is incorrect about it? We are not the only arch that does that.

I'm not clear on what has changed to break this?

cheers

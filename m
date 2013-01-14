Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3ANLKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:10:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:58459 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab3ANLKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:10:43 -0500
Date: Mon, 14 Jan 2013 12:10:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nico@linaro.org, will.deacon@arm.com, marc.zyngier@arm.com,
        john.stultz@linaro.org
Subject: Re: [PATCHv2 3/4] clockevents: Add generic timer broadcast
 function
In-Reply-To: <1357742770-15028-4-git-send-email-mark.rutland@arm.com>
Message-ID: <alpine.LFD.2.02.1301141209290.7475@ionos>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com> <1357742770-15028-4-git-send-email-mark.rutland@arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013, Mark Rutland wrote:
> Currently, the timer broadcast mechanism is defined by a function
> pointer on struct clock_event_device. As the fundamental mechanism for
> broadcast is architecture-specific, this means that clock_event_device
> drivers cannot be shared across multiple architectures.
> 
> This patch adds an (optional) architecture-specific function for timer
> tick broadcast, allowing drivers which may require broadcast
> functionality to be shared across multiple architectures.

Looks good.

If you fixup the first one of the series, I'll take the generic
patches and provide a branch to pull for the ARM folks, so the ARM
part can go via their tree.

Thanks,

	tglx

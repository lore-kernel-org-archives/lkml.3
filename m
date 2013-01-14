Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3ANIjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:39:32 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46310 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab3ANIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:39:31 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-2b-50f3c441b0f8
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 22/22] sched: lazy powersaving balance
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	<1357375071-11793-23-git-send-email-alex.shi@intel.com>
Date: Mon, 14 Jan 2013 17:39:29 +0900
In-Reply-To: <1357375071-11793-23-git-send-email-alex.shi@intel.com> (Alex
	Shi's message of "Sat, 5 Jan 2013 16:37:51 +0800")
Message-ID: <877gngnoou.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Jan 2013 16:37:51 +0800, Alex Shi wrote:
> +	/*
> +	 * The situtatoin isn't egligible for performance balance. If this_cpu

s/situtatoin/situation/

s/egligible/eligible/

> +	 * is not egligible or the timing is not suitable for lazy powersaving

Thanks,
Namhyung


> +	 * balance, we will stop both powersaving and performance balance.
> +	 */

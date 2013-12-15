Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LOSe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 13:34:28 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:51963 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3LOSe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 13:34:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131215155539.GM11295@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
	<CA+55aFyNAigQqBk07xLpf0nkhZ_x-QkBYG8otRzsqg_8A2eg-Q@mail.gmail.com>
	<20131215155539.GM11295@suse.de>
Date: Sun, 15 Dec 2013 10:34:25 -0800
X-Google-Sender-Auth: 0g9fCO4OLravB-rWdRnf4tDsres
Message-ID: <CA+55aFz5ZTEiEELhPaQd97TorAKjqrKCmJc9O0NE1Nyri65Pzw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 7:55 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> Short answer -- There appears to be a second bug where 3.13-rc3 is less
> fair to threads getting time on the CPU.

Hmm.  Can you point me at the (fixed) microbenchmark you mention?

              Linus

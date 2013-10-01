Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3JAG7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:59:54 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58658 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3JAG7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:59:53 -0400
Date: Tue, 1 Oct 2013 08:59:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] x86/geode: fix incorrect placement of __initdata tag
Message-ID: <20131001065950.GC19718@gmail.com>
References: <18427893.G5JGWn465D@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18427893.G5JGWn465D@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:

> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/x86/platform/geode/alix.c    | 2 +-
>  arch/x86/platform/geode/geos.c    | 2 +-
>  arch/x86/platform/geode/net5501.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Does this fix have any runtime effects, i.e. should we queue this up as an 
urgent fix for v3.12, or does tip:x86/platform with a v3.13 merge suffice?

Thanks,

	ingo

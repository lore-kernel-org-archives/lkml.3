Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKIIWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 03:22:55 -0500
Received: from tux-cave.hellug.gr ([195.134.99.74]:44160 "EHLO
	tux-cave.hellug.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaKIIWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 03:22:54 -0500
X-Hellug-MailScanner-From: xrg@linux.gr
X-Hellug-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.9, required 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90)
X-Hellug-MailScanner: Found to be clean
X-Hellug-MailScanner-ID: sA98MUBb004841
From: "P. Christeas" <xrg@linux.gr>
To: Hillf Danton <hillf.zj@alibaba-inc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: "'Vlastimil Babka'" <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
Date: Sun, 09 Nov 2014 10:22:26 +0200
Message-ID: <1433036.WjB5pb09Zh@xorhgos3.pefnos>
User-Agent: KMail/4.12.5 (Linux/3.18.0-rc3+; KDE/4.12.5; x86_64; ; )
In-Reply-To: <00a801cffbd8$434189b0$c9c49d10$@alibaba-inc.com>
References: <00a801cffbd8$434189b0$c9c49d10$@alibaba-inc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 November 2014, Hillf Danton wrote:
> -		return COMPACT_CONTINUE;
> +		return COMPACT_SKIPPED;

I guess this one would mitigate against Vlastmil's migration scanner issue, 
wouldn't it?

In that case, I should wait a bit[1] to try the first patch, then revert, try 
yours and (hopefully) have some results.

Then, apply both.

[1] trying to push the vm by loading memory-hungry apps and random load.

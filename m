Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaKEQDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:03:54 -0500
Received: from tux-cave.hellug.gr ([195.134.99.74]:36007 "EHLO
	tux-cave.hellug.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbaKEQDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:03:49 -0500
X-Hellug-MailScanner-From: xrg@linux.gr
X-Hellug-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.9, required 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90)
X-Hellug-MailScanner: Found to be clean
X-Hellug-MailScanner-ID: sA5G3LM8012234
From: "P. Christeas" <xrg@linux.gr>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
Date: Wed, 05 Nov 2014 18:02:02 +0200
Message-ID: <2478068.rAhurny29o@xorhgos3.pefnos>
User-Agent: KMail/4.12.5 (Linux/3.18.0-rc3+; KDE/4.12.5; x86_64; ; )
In-Reply-To: <545A419C.3090900@suse.cz>
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos> <2357788.X5UHX7WJZF@xorhgos3.pefnos> <545A419C.3090900@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 November 2014, Vlastimil Babka wrote:
> I see. I've tried to reproduce such issues with 3.18-rc3 but wasn't
> successful. But I noticed a possible issue that could lead to your problem.
> Can you please try the following patch?

OK, I can give it a try.

FYI, the "stability canary" is still alive, my system is on for 28hours, under 
avg. load >=3 all this time, HEAD=980d0d51b1c9617a4

/me goes busy fire-proofing your patch...




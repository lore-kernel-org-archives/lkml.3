Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaKJIOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:14:37 -0500
Received: from tux-cave.hellug.gr ([195.134.99.74]:54217 "EHLO
	tux-cave.hellug.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaKJIOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:14:36 -0500
X-Hellug-MailScanner-From: xrg@linux.gr
X-Hellug-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.9, required 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90)
X-Hellug-MailScanner: Found to be clean
X-Hellug-MailScanner-ID: sAA8EBMQ021897
From: "P. Christeas" <xrg@linux.gr>
To: Vlastimil Babka <vbabka@suse.cz>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        lkml <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
Date: Mon, 10 Nov 2014 10:14:10 +0200
Message-ID: <3191541.VgF98cnILq@xorhgos3.pefnos>
User-Agent: KMail/4.12.5 (Linux/3.18.0-rc3+; KDE/4.12.5; x86_64; ; )
In-Reply-To: <545E96BD.5040103@suse.cz>
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos> <3443150.6EQzxj6Rt9@xorhgos3.pefnos> <545E96BD.5040103@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 November 2014, Vlastimil Babka wrote:
> >From fbf8eb0bcd2897090312e23da6a31bad9cc6b337 Mon Sep 17 00:00:00 2001
> 
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Sat, 8 Nov 2014 22:20:43 +0100
> Subject: [PATCH] mm, compaction: prevent endless loop in migrate scanner

After 30hrs uptime, I also mark this test as PASSED .

:)


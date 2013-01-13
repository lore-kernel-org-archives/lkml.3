Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3AMQMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 11:12:47 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33282 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3AMQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 11:12:46 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 13 Jan 2013 17:12:45 +0100
Message-ID: <CA+icZUW5kryOCpX96CkaS=5uX61FmiYE0mh7y6F0eT9Bh8eUGw@mail.gmail.com>
Subject: Unique commit-id for "mm: compaction: [P,p]artially revert capture of
 suitable high-order page"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I see two different commit-id for an identical patch (only subject
line differs).
[1] seems to be applied directly and [2] came with a merge of akpm-fixes.
What is in case of backports for -stable kernels?

Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=47ecfcb7d01418fcbfbc75183ba5e28e98b667b2
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8fb74b9fb2b182d54beee592350d9ea1f325917a

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaL3Uvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 15:51:33 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:56739 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaL3Uvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 15:51:31 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1417567367-9298-1-git-send-email-mgorman@suse.de>
References: <1417567367-9298-1-git-send-email-mgorman@suse.de>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 30 Dec 2014 21:51:11 +0100
Message-ID: <CAKgNAkgX8z=hZofSqkAb9VA_9mMBbRBDHdkX9NUentHSP4Lkog@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve documentation of FADV_DONTNEED behaviour
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 1:42 AM, Mel Gorman <mgorman@suse.de> wrote:
> Partial page discard requests are ignored and the documentation on why this
> is correct behaviour sucks. A readahead patch looked like a "regression" to
> a random IO storage benchmark because posix_fadvise() was used incorrectly
> to force IO requests to go to disk. In reality, the benchmark sucked but
> it was non-obvious why. Patch 1 updates the kernel comment in case someone
> "fixes" either readahead or fadvise for inappropriate reasons. Patch 2
> updates the relevant man page on the rough off chance that application
> developers do not read kernel source comments.

It feels like that last sentence should have made LWN quote of the week :-/.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

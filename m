Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbaDVSDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbaDVSDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:03:22 -0400
Date: Tue, 22 Apr 2014 14:03:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: 3.15rc2 hanging processes on exit.
Message-ID: <20140422180308.GA19038@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a test box that's running my fuzzer that is in an odd state.
The processes are about to end, but they don't seem to be making any
progress.  They've been spinning in the same state for a few hours now..

perf top -a is showing a lot of time is being spent in page_fault and bad_gs

there's a large trace file here from the function tracer:
http://codemonkey.org.uk/junk/trace.out

	Dave


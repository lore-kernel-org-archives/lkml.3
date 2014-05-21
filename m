Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaEULab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:30:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:39411 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaEULaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:30:30 -0400
Date: Wed, 21 May 2014 13:30:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org
Subject: Re: [V6 01/11] perf: Add PERF_SAMPLE_BRANCH_COND
Message-ID: <20140521113025.GC2485@laptop.programming.kicks-ass.net>
References: <1400666396-1682-1-git-send-email-khandual@linux.vnet.ibm.com>
 <1400666396-1682-2-git-send-email-khandual@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400666396-1682-2-git-send-email-khandual@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:29:46PM +0530, Anshuman Khandual wrote:
> This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
> will extend the existing perf ABI. Various architectures can provide
> this functionality with either with HW filtering support (if present)
> or with SW filtering of captured branch instructions.

The Changelog fails to mention what _this_ functionality is.


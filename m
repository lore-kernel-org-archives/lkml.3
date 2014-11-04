Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaKDNUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:20:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:37068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaKDNUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:20:53 -0500
Date: Tue, 4 Nov 2014 14:20:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/5] perf, x86: Add Broadwell core support
Message-ID: <20141104132047.GN3337@twins.programming.kicks-ass.net>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
 <1409006611-30741-4-git-send-email-andi@firstfloor.org>
 <20140901135129.GN27892@worktop.ger.corp.intel.com>
 <CABPqkBTn5cFNWSmbCnUPepOTyO2sx5ch=-=kbzfG+n2HU5pftA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTn5cFNWSmbCnUPepOTyO2sx5ch=-=kbzfG+n2HU5pftA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 02:14:59PM +0100, Stephane Eranian wrote:
> What's happening with Broadwell support?
> I don't see any support in 3.18-rc2. We need
> this ASAP now.

lkml.kernel.org/r/tip-1776b10627e486dd431fe72d8d47e5a865cf65d1@git.kernel.org

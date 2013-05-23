Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935Ab3EWXPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 19:15:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56446 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888Ab3EWXPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 19:15:41 -0400
Date: Fri, 24 May 2013 00:15:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
	decompressor
Message-ID: <20130523231531.GT18614@n2100.arm.linux.org.uk>
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org> <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519E57D2.3050000@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:54:26AM -0700, Stephen Boyd wrote:
> On 05/15/13 12:38, Stephen Boyd wrote:
> > On 05/08/13 14:47, Stephen Boyd wrote:
> >> From: Brian Swetland <swetland@google.com>
> >>
> >> Currently v7 CPUs with an MIDR that has no bits set in the range
> >> [16:12] will be detected as old ARM CPUs with no caches and so
> >> the cache will never be turned on during decompression. ARM's
> >> Cortex chips have an 0xC in the range [16:12] so they never match
> >> this entry, but Qualcomm's Scorpion and Krait processors never
> >> set these bits to anything besides 0 so they always match.
> >>
> >> Skip this entry if we've compiled in support for v7 CPUs. This
> >> allows kernel decompression to happen nearly instantly instead of
> >> taking over 20 seconds.
> >>
> >> Signed-off-by: Brian Swetland <swetland@google.com>
> >> [sboyd: Clarified and extended commit text]
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> ---
> > Ping?
> 
> Russell, shall I add this to the patch tracker?

Yes please.


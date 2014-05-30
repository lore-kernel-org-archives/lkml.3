Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaE3Hen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:34:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:51411 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbaE3Hel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:34:41 -0400
Date: Fri, 30 May 2014 09:34:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/4] perf: Handle guest PEBS events with a fake event
Message-ID: <20140530073439.GB20167@laptop.programming.kicks-ass.net>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401412327-14810-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:12:06PM -0700, Andi Kleen wrote:

> Note: in very rare cases with exotic events this may lead to spurious PMIs
> in the guest.

Qualify that statement so that if someone runs into it we at least know
it is known/expected.

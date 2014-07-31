Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaGaTVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:21:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaGaTVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:21:36 -0400
Date: Thu, 31 Jul 2014 21:21:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH 3/4] perf/x86/uncore: move SNB-EP/IvyTown specific code
 to seperate file
Message-ID: <20140731192132.GN18735@two.firstfloor.org>
References: <1406704935-27708-1-git-send-email-zheng.z.yan@intel.com>
 <1406704935-27708-3-git-send-email-zheng.z.yan@intel.com>
 <20140730090525.GE19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730090525.GE19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:05:25AM +0200, Peter Zijlstra wrote:
> 
> 
> What's Ivytown? Is that IVB-EP or EX or both? I want to fix the subject
> to not mix and match these terms.

IvyTown is EP and EX and some other marketing names.

-Andi

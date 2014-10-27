Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaJ0MXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:23:44 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48264 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaJ0MXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:23:43 -0400
Date: Mon, 27 Oct 2014 13:23:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to cleanup the HSW offcore bits
Message-ID: <20141027122340.GU12538@two.firstfloor.org>
References: <20141023105119.173457103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023105119.173457103@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:51:19PM +0200, Peter Zijlstra wrote:
> So Don asked about offcore and because I forgot I looked at the code and found
> the terrible mess Andi created with the HSW/BDW bits.
> 
> This series attempts to clean some of that up but seeing how it was all magic
> numbers 

All the bits are documented. The actual definitions are available
in the JSON offcore definitions at https://download.01.org/perfmon/

> and no reasons provided for the differences with existing uarchs this
> might just break things horribly.
> That said, if this does break things, fixes will have to explain things, so
> that's good.

I trust you won't submit or merge untested patches.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3JIDYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:24:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42362 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3JIDYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:24:40 -0400
Date: Wed, 9 Oct 2013 05:24:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131009032439.GR6882@two.firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
 <20131008065938.GA4333@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008065938.GA4333@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I test-built a config close to your config with both tracing and perf 
> on and off (note, I had OPROFILE and KVM in a module), and got the 
> following kernel sizes:

Yes I mistakenly included KVM (I think that was the difference)
Without KVM it's ~272k text, 96k BSS data delta.

Still big, but not quite as bad as I made it out to be.

Thanks for catching.

-Andi

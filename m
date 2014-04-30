Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaD3IzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:55:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:34779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaD3IzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:55:10 -0400
Date: Wed, 30 Apr 2014 10:55:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Subject: Re: [PATCH] lib/spinlock_debug: Tweak the loop time to fit different
 _delay()
Message-ID: <20140430085508.GE30445@twins.programming.kicks-ass.net>
References: <1398897638.21870.8.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398897638.21870.8.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 06:40:38PM -0400, Wang, Xiaoming wrote:
> loops_per_jiffy*Hz  is not always 1 second exactly
> it depends on the realization of _delay() .
> delay_tsc is used as _delay() in arch/x86/lib/delay.c

This just states delay() is broken. The primary response should be to
try and fix that, no?

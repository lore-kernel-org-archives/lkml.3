Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaCQQRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:17:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37172 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaCQQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:16:36 -0400
Date: Mon, 17 Mar 2014 17:16:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: eranian@google.com, jmario@redhat.com, jolsa@redhat.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: perf MMAP2 interface and COW faults
Message-ID: <20140317161627.GI25546@laptop.programming.kicks-ass.net>
References: <20140313200352.GU25953@redhat.com>
 <20140314111705.GU27965@twins.programming.kicks-ass.net>
 <20140317153747.GH25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317153747.GH25953@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 11:37:47AM -0400, Don Zickus wrote:
> Yes this seemed to work.  I attached a slight update to your patch (one
> that compiles :-) ).  And I will reply to this thread with the tool
> changes I used to verify this (in case I did that piece wrong).

:-)

OK, I'll write it a changelog and queue. Thanks!

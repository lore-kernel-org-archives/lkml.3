Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaAVK2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:28:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50640 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaAVK2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:28:14 -0500
Date: Wed, 22 Jan 2014 11:27:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] sched_clock: wrong printk time stamp
Message-ID: <20140122102757.GI31570@twins.programming.kicks-ass.net>
References: <20140122095219.GA6114@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122095219.GA6114@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 05:52:19PM +0800, Dave Young wrote:
> Hi,
> 
> With today's Linus tree, the printk time is very odd, see below

please follow the thread here:

lkml.kernel.org/r/52DEF495.2020304@oracle.com

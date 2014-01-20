Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaATTLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:11:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36503 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaATTLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:11:04 -0500
Date: Mon, 20 Jan 2014 20:10:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, chegu_vinod@hp.com,
        mgorman@suse.de, mingo@redhat.com
Subject: Re: [PATCH 6/7] numa,sched: normalize faults_from stats and weigh by
 CPU use
Message-ID: <20140120191051.GQ11314@laptop.programming.kicks-ass.net>
References: <1389993129-28180-1-git-send-email-riel@redhat.com>
 <1389993129-28180-7-git-send-email-riel@redhat.com>
 <20140120165747.GL31570@twins.programming.kicks-ass.net>
 <52DD72C8.2050602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD72C8.2050602@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 02:02:32PM -0500, Rik van Riel wrote:
> That is what I started out with, and the results were not
> as stable as with this calculation.
> 
> Having said that, I did that before I came up with patch 7/7,
> so maybe the effect would no longer be as pronounced any more
> as it was before...
> 
> I can send in a simplified version, if you prefer.

If you could retry with 7/7, I don't mind adding the extra stats too
much, but it would be nice if we can avoid it.

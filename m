Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaAFMev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:34:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaAFMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:34:34 -0500
Date: Mon, 6 Jan 2014 13:34:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Calculate effective load even if local weight is 0
Message-ID: <20140106123420.GJ31570@twins.programming.kicks-ass.net>
References: <20140106113912.GC6178@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106113912.GC6178@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 11:39:12AM +0000, Mel Gorman wrote:
> (Rik, you authored this patch so it should be sent from you and needs a
> signed-off assuming people are ok with the changelog.)

Where did all this take place? I saw the initial email I think but then
nothing..

Not that I was reading much email the past two weeks anyway :-)

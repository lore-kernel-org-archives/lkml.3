Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3KKQ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:28:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38242 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3KKQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:28:09 -0500
Date: Mon, 11 Nov 2013 17:27:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        mingo@redhat.com
Subject: Re: [PATCH v3 0/2] ARC: Add perf support for ARC700 cores
Message-ID: <20131111162755.GC26898@twins.programming.kicks-ass.net>
References: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 02:55:10PM +0100, Mischa Jonker wrote:
> Hi all,
> 
> Please find v3 of my attempt to add support for perf for ARC700 PMU's. If
> possible, it would be nice to get some feedback on the implementation from
> non-ARC/Synopsys people familiar with the perf subsystem in Linux.

Anything in particular you wanted feedback on? It looks like a fairly
straight fwd thingy.

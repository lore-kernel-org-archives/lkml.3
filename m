Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaCFJLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:11:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaCFJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:11:13 -0500
Date: Thu, 6 Mar 2014 10:11:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Lu <zlu@tilera.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] tile: Add support for handling PMC hardware
Message-ID: <20140306091102.GG9987@twins.programming.kicks-ass.net>
References: <BAB94DBB0E89D8409949BC28AC95914C5D67FF17@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C5D67FF17@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 06:13:48AM +0000, Tony Lu wrote:

The changelogs are all very sparse. But in general the stuff looks to
have the right shape.

It looks like you do software NMIs with interrupt priority levels; which
is a perfectly fine way, other archs do the same.

One thing I didn't spot is a tile irq_work implementation; perf likes to
have one.


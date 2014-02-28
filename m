Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaB1Lp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:45:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaB1LpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:45:06 -0500
Date: Fri, 28 Feb 2014 12:44:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Du, Yuyang" <yuyang.du@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC] Splitting scheduler into two halves
Message-ID: <20140228114459.GM27965@twins.programming.kicks-ass.net>
References: <0DA73B5D686AEC4AAEF6054BE04DA1CD116C50EA@SHSMSX102.ccr.corp.intel.com>
 <20140228102932.GI19029@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228102932.GI19029@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:29:32AM +0000, Morten Rasmussen wrote:
> If I understand your proposal correctly, you are proposing to have a
> pluggable scheduler where it is possible to have many different
> load-balance (bottom half) implementations.

Yeah, that's not _ever_ going to happen. We've had that discussion many
times, use your favourite search engine.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbaJ1IZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:25:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397AbaJ1IZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:25:12 -0400
Date: Tue, 28 Oct 2014 09:25:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
Message-ID: <20141028082503.GN3337@twins.programming.kicks-ass.net>
References: <5446787E.60202@linux.intel.com>
 <20141024153656.GM12706@worktop.programming.kicks-ass.net>
 <544DE5CF.9040501@linux.intel.com>
 <20141027074419.GE10501@worktop.programming.kicks-ass.net>
 <544F4B31.7050308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544F4B31.7050308@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:52:17PM +0800, Li, Aubrey wrote:

> Both clocksource and clockevents are not per-cpu device, why do we need
> to run their suspend callback on *each* cpu?

Uhm, you mean to say we don't use per-cpu timer lists and per-cpu timer
hardware for clockevents then?

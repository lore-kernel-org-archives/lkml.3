Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaKJLtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:49:40 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaKJLti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:49:38 -0500
Date: Mon, 10 Nov 2014 12:49:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Sleep: Timer quiesce in freeze state
Message-ID: <20141110114928.GK3337@twins.programming.kicks-ass.net>
References: <5446787E.60202@linux.intel.com>
 <20141029082432.GV3337@twins.programming.kicks-ass.net>
 <5451A94F.1090200@linux.intel.com>
 <4545011.reftWMuc6g@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4545011.reftWMuc6g@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 03:05:56AM +0100, Rafael J. Wysocki wrote:
> Peter, Thomas, any comments here?

I'm fine with this; but Thomas needs to ack, lets give him a few more
days to reply with this reminder.

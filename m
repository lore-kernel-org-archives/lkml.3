Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaDWOed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:34:33 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:63582 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaDWOea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:34:30 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.um.maine.edu>
Date: Wed, 23 Apr 2014 10:37:55 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
In-Reply-To: <alpine.DEB.2.10.1404231013380.30238@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1404231036570.30238@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu> <20140423102254.GL11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231013380.30238@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014, Vince Weaver wrote:
> 
> I suppose I should make a patch for attr->sample_type and 
> attr->read_format which after a quick audit seem to exhibit the same 
> problem?

nevermind, PERF_FORMAT_MAX and PERF_SAMPLE_MAX are enum values, not 
#defines, so they handle being 64-bit properly.

Vince

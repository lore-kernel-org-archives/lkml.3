Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3KLJop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:44:45 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:49240 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3KLJol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:44:41 -0500
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vineet.Gupta1@synopsys.com" <Vineet.Gupta1@synopsys.com>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: RE: [PATCH v3 0/2] ARC: Add perf support for ARC700 cores
Thread-Topic: [PATCH v3 0/2] ARC: Add perf support for ARC700 cores
Thread-Index: AQHO28D+5ybZczaeNE+tHSTnYRzkg5ogLa2AgAAAxwCAASl7wA==
Date: Tue, 12 Nov 2013 09:44:34 +0000
Message-ID: <E6BF041E97966E4DB955F0DF883AD2D685F17293@de02wembxa.internal.synopsys.com>
References: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
 <20131111162755.GC26898@twins.programming.kicks-ass.net>
 <20131111163042.GA10977@twins.programming.kicks-ass.net>
In-Reply-To: <20131111163042.GA10977@twins.programming.kicks-ass.net>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.24.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, so its one of those that cannot sample; you might want to fail when we
> try and create a sampling event.

Good suggestion, I'll create a separate patch for that!

> Also, you could consider running an (hr)timer to periodically update the
> events so that you don't miss a hardware counter wrap around -- if that is a
> distinct possibility.

It's a theoretical possibility: the counters are 48 bits. Unlikely to happen
during application development/performance analysis on an embedded core.

Thanks,

Mischa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3KLJPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:15:19 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:55015 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3KLJPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:15:15 -0500
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
Thread-Index: AQHO28D+5ybZczaeNE+tHSTnYRzkg5ogLa2AgAEogTA=
Date: Tue, 12 Nov 2013 09:15:12 +0000
Message-ID: <E6BF041E97966E4DB955F0DF883AD2D685F17276@de02wembxa.internal.synopsys.com>
References: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
 <20131111162755.GC26898@twins.programming.kicks-ass.net>
In-Reply-To: <20131111162755.GC26898@twins.programming.kicks-ass.net>
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

Hi Peter,

> > Please find v3 of my attempt to add support for perf for ARC700 PMU's.
> > If possible, it would be nice to get some feedback on the
> > implementation from non-ARC/Synopsys people familiar with the perf
> subsystem in Linux.
> 
> Anything in particular you wanted feedback on? It looks like a fairly
> straight fwd thingy.

This may just be my lack of experience with kernel etiquette; the patch
works OK for us, but it would be a bit strange if Vineet would just apply
it without any discussion on the mailing list. So thanks for having taken
the time to look at it!

Mischa

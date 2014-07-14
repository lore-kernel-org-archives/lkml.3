Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaGNNoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:44:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:65213 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbaGNNon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:44:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,658,1400050800"; 
   d="scan'208";a="456724467"
From: "Liang, Kan" <kan.liang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V5 1/2] perf ignore LBR and extra_regs
Thread-Topic: [PATCH V5 1/2] perf ignore LBR and extra_regs
Thread-Index: AQHPnG+hivFH9gFqr0Syb8Ke5/aDbZue9emAgAAEAACAAAi2gIAAjmog//+CP4CAAIaGUA==
Date: Mon, 14 Jul 2014 13:44:32 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014E1B03@SHSMSX103.ccr.corp.intel.com>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
 <53C3C517.4000500@redhat.com>
 <20140714120922.GV9918@twins.programming.kicks-ass.net>
 <53C3CFC1.9070800@redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F077014E1A91@SHSMSX103.ccr.corp.intel.com>
 <53C3DDBB.2000304@redhat.com>
In-Reply-To: <53C3DDBB.2000304@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Monday, July 14, 2014 9:40 AM
> To: Liang, Kan; Peter Zijlstra
> Cc: andi@firstfloor.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
> 
> Il 14/07/2014 15:36, Liang, Kan ha scritto:
> >> > Kan Liang, what happens if CONFIG_PARAVIRT=y?  Do you get garbage
> >> > or just no events reported?
> >> >
> > Guest rdmsr/wrmsr will eventually call rdmsr_safe/wrmsr_safe. They will
> handle the #GP. So there is no error report in guest.
> 
> Yeah, but what's the effect on the output of perf?

They can be still counted/sampled, but the results are garbage.

Kan

> 
> Paolo


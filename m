Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaGOPc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:32:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:34476 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaGOPcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:32:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,666,1400050800"; 
   d="scan'208";a="573490948"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V6 1/2] perf ignore LBR and extra_rsp
Thread-Topic: [PATCH V6 1/2] perf ignore LBR and extra_rsp
Thread-Index: AQHPn9r56Kxi05UQukeQ1s9vl18uIZuguEoAgACJHXA=
Date: Tue, 15 Jul 2014 15:32:36 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014F0CF3@SHSMSX103.ccr.corp.intel.com>
References: <1405365957-20202-1-git-send-email-kan.liang@intel.com>
 <20140715151130.GK6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140715151130.GK6758@twins.programming.kicks-ass.net>
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



> 
> 
> Since nobody ever treats EVENT_EXTRA_END as an actual event, the value
> of .extra_msr_access is irrelevant, this leaves the only 'possible'
> value 'true' and we can delete all those changes.
> 
Right.
> Which, combined with a few whitespace cleanups, gives the below patch.

Thanks. Your change is perfect. Do I need to resubmit the patch to the mailing list?

Thanks,
Kan 


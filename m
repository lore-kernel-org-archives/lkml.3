Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaKLOou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:44:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:30887 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaKLOos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:44:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,369,1413270000"; 
   d="scan'208";a="621220571"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH 1/2] perf tools: enable LBR call stack support
Thread-Topic: [PATCH 1/2] perf tools: enable LBR call stack support
Thread-Index: AQHP+dQEr3gweYpzV0K6hl21UOh2dJxcIPuAgAD3ybA=
Date: Wed, 12 Nov 2014 14:44:42 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701661933@SHSMSX103.ccr.corp.intel.com>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <1415285886-16949-2-git-send-email-kan.liang@intel.com>
 <20141112075049.GB22994@krava>
In-Reply-To: <20141112075049.GB22994@krava>
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



> PERF_SAMPLE_BRANCH_USER |
> > +
> 	PERF_SAMPLE_BRANCH_CALL_STACK;
> > +			attr->exclude_user = 0;
> 
> I think we shouldn't siletly change attr->exclude_user, if it was defined, we
> need to display warning that we are changing that or fail
> 

Right, I will display a warning here.

Thanks,
Kan

> jirka

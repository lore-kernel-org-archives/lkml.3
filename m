Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaKJOIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:08:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:32782 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaKJOIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:08:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414286737"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@redhat.com" <jolsa@redhat.com>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH 0/2] perf tool: Haswell LBR call stack support (user)
Thread-Topic: [PATCH 0/2] perf tool: Haswell LBR call stack support (user)
Thread-Index: AQHP+dQEhkA8OrF8t0i43+9TGZE3/JxZL6EAgAC5asA=
Date: Mon, 10 Nov 2014 14:08:38 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770165F29D@SHSMSX103.ccr.corp.intel.com>
References: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
 <20141110105428.GH3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141110105428.GH3337@twins.programming.kicks-ass.net>
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

 
> acme, jolsa, ACK on these two?

These patches are pure user tool patches. I usually sent the tool
patches to them for review. Also, Jolsa had some comments on
the previous perf tool part. So I would like them have a look
at the new changes of the user tool.

Thanks,
Kan

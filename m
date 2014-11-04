Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKDBKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:10:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:56646 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaKDBKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:10:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="625926874"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: RE: [PATCH V6 01/17] perf, x86: Reduce lbr_sel_map size
Thread-Topic: [PATCH V6 01/17] perf, x86: Reduce lbr_sel_map size
Thread-Index: AQHP6+jMIFOfPtuFiEWBy93ExshP9Jw+fuMAgBE/+AA=
Date: Tue, 4 Nov 2014 01:07:39 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016530FB@SHSMSX103.ccr.corp.intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
 <1413755712-8259-2-git-send-email-kan.liang@intel.com>
 <20141024093930.GD12706@worktop.programming.kicks-ass.net>
In-Reply-To: <20141024093930.GD12706@worktop.programming.kicks-ass.net>
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

Hi Peter,

Did you get a chance to review the rest of the patch set?

Thanks,
Kan
> 
> On Sun, Oct 19, 2014 at 05:54:56PM -0400, Kan Liang wrote:
> 
> This should still very much have:
> 
> From: Yan, Zheng <zheng.z.yan@intel.com>
> 
> Seeing how you did not write this patch, probably true for all the others
> too, although I've not checked yet.
> 
> > The index of lbr_sel_map is bit value of perf branch_sample_type.
> > PERF_SAMPLE_BRANCH_MAX is 1024 at present, so each lbr_sel_map
> uses
> > 4096 bytes. By using bit shift as index, we can reduce lbr_sel_map
> > size to 40 bytes. This patch defines 'bit shift' for branch types, and
> > use 'bit shift' to define lbr_sel_maps.
> >
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > Signed-off-by: Kan Liang <kan.liang@intel.com>
> > Reviewed-by: Stephane Eranian <eranian@google.com>
> > ---


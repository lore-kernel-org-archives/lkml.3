Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3CTQcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:32:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:2691 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837Ab3CTQcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:32:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,879,1355126400"; 
   d="scan'208";a="216991476"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Shaun Ruffell <sruffell@digium.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [3.9-rc1] Bug in bootup code or debug code?
Thread-Topic: [3.9-rc1] Bug in bootup code or debug code?
Thread-Index: AQHOH+41JMUeuBHQvESU+8AmIyoShpijvDbQgACeM4CAADKXgIAJEDzggAGFlQD//62lwA==
Date: Wed, 20 Mar 2013 16:32:14 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205594724E@ORSMSX105.amr.corp.intel.com>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
 <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
 <201303132224.BEC60922.JStQOFMVFFOHLO@I-love.SAKURA.ne.jp>
 <3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
 <5140BB13.10806@linux.intel.com>
 <201303140545.DAC69253.FtSJOOFMHVFOLQ@I-love.SAKURA.ne.jp>
 <3E5A0FA7E9CA944F9D5414FEC6C7122055946F23@ORSMSX105.amr.corp.intel.com>
 <20130320142444.GA10492@digium.com>
In-Reply-To: <20130320142444.GA10492@digium.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Shaun Ruffell [mailto:sruffell@digium.com]
> On Tue, Mar 19, 2013 at 10:12:39PM +0000, Yu, Fenghua wrote:
> > > From: Tetsuo Handa [mailto:penguin-kernel@I-love.SAKURA.ne.jp]
> > > H. Peter Anvin wrote:
 
> Hi Fenghua,
> 
> I ran into the same issue on a test system I use (not a virtual
> machine) and went through basically the same process as Dave
> Hansen w/bisecting before finding this thread.
> 
> Any chance you could send the patch to the mailing list and I could
> also throw it on my test system?
Hi, Shaun,

The patch is in tip.git tree now. You can get it from:
http://git.kernel.org/tip/c83a9d5e425d4678b05ca058fec6254f18601474

Please let us know if the patch fixes the issue you saw.

Thanks.

-Fenghua

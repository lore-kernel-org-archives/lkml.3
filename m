Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaLBPvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:51:20 -0500
Received: from mga03.intel.com ([134.134.136.65]:22752 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbaLBPvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:51:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,501,1413270000"; 
   d="scan'208";a="617333128"
From: "Liang, Kan" <kan.liang@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V5 1/1] perf tool:perf diff support for different
 binaries
Thread-Topic: [PATCH V5 1/1] perf tool:perf diff support for different
 binaries
Thread-Index: AQHQBaYHbW9h/AG/lUGstzYY6rEaqpx63N2AgAGnIsA=
Date: Tue, 2 Dec 2014 15:51:13 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770167815D@SHSMSX103.ccr.corp.intel.com>
References: <1416585348-14762-1-git-send-email-kan.liang@intel.com>
 <20141201223541.GM30226@kernel.org>
In-Reply-To: <20141201223541.GM30226@kernel.org>
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
> Em Fri, Nov 21, 2014 at 10:55:48AM -0500, kan.liang@intel.com escreveu:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > Currently, the perf diff only works with same binaries. That's because
> > it compares the symbol start address. It doesn't work if the perf.data
> > comes from different binaries. This patch matches the function names.
> >
> > Here is a simple examples (Only change f2 and f3 functions location.)
> > There is no change in behavior, but the old perf diff display the
> > wrong differential profile.
> 
> [acme@zoo linux]$ am /wb/1.patch
> Applying: perf tool:perf diff support for different binaries
> /home/acme/git/linux/.git/rebase-apply/patch:23: trailing whitespace.
> If no parameters are passed the samples will be sorted by dso and symbol.
> /home/acme/git/linux/.git/rebase-apply/patch:26: trailing whitespace.
> symbols name.
> warning: 2 lines add whitespace errors.
> 

Sorry for the inconvenience, I will repost a clean version then.

Thanks,
Kan

> [1]+  Stopped                 am /wb/1.patch
> [acme@zoo linux]$
> 
> Fixing this up this time.
> 
> Please consider:
> 
> chmod +x .git/hooks/*
> 
> - Arnaldo

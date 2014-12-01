Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaLAUSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:18:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbaLAUST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:18:19 -0500
Date: Mon, 1 Dec 2014 21:18:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "acme@kernel.org" <acme@kernel.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V6 1/3] perf tool: Add sort key symoff for perf diff
Message-ID: <20141201201813.GA9165@krava.brq.redhat.com>
References: <1417444812-22063-1-git-send-email-kan.liang@intel.com>
 <20141201195345.GA13302@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F07701677D8E@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701677D8E@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 08:05:48PM +0000, Liang, Kan wrote:

SNIP

> >      0.05%           main+0x14c
> >      1.40%   -0.26%  main+0x155
> >      0.07%           main+0x158
> >      0.74%   -0.03%  main+0x15b
> >      1.06%   -0.17%  main+0x160
> >      0.31%   +0.30%  main+0x1a8
> >      1.82%   -0.51%  main+0x1af
> >      0.09%   +0.07%  main+0x1b1
> >      0.05%           main+0x1b4
> > 
> > could we add something like '-s symstr' to do only symbol string
> > comparison, so the previous output would gather in single line like:
> > 
> >      5.09%   +2.07%  main
> 
> Yes, we have a patch to do that.
> https://lkml.org/lkml/2014/11/21/367
> The default sort key "symbol" do symbols names comparison.
> 
> The symoff here is an extension in case anyone want to do deeper analysis.

cool, I just acked it

thanks,
jirka

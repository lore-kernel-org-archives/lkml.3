Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaLDQCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:02:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbaLDQC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:02:28 -0500
Date: Thu, 4 Dec 2014 17:02:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "Liang, Kan" <kan.liang@intel.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: Re: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Message-ID: <20141204160213.GB18631@krava.brq.redhat.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
 <20141204142330.GB10406@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
 <20141204155142.GD18689@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204155142.GD18689@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:51:42PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 04, 2014 at 02:49:52PM +0000, Liang, Kan escreveu:
> > Jiri Wrote:
> > > looks ok to me..
>  
> > Thanks for the review.
>  
> > > I'll test it once I get hands on Haswel server again, I guess we wait for the
> > > kernel change to go in first anyway, right?
>  
> > I'm not sure, let's ask Peter.
>  
> > Peter?
> 
> Would be good to go in one pull request, so that whoever pulls it has
> the chance to test the kernel feature with the accompanying tooling bits.

also there's user part dependency on kernel.. soem new define IIRC

jirka

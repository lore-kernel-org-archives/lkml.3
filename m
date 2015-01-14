Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbbANN7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:59:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbbANN7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:59:35 -0500
Date: Wed, 14 Jan 2015 11:59:30 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, namhyung@kernel.org,
        jolsa@kernel.org, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-arch@vger.kernel.org, Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH v3 0/5] Perf tool fixes for ARC + uClibc
Message-ID: <20150114135930.GA2463@redhat.com>
References: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
 <20150114120000.GB11443@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114120000.GB11443@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 14, 2015 at 01:00:00PM +0100, Jiri Olsa escreveu:
> On Tue, Jan 13, 2015 at 07:13:19PM +0530, Vineet Gupta wrote:
> > Hi,
> > 
> > This series based off linux-next of 20150105 allows us to build/use perf
> > for ARC with uClibc based userland.
> > 
> > v3: Changes since v2 [2]
> > * 1/5	: Ack from Jiri
> > * 2/5	: no changes
> > * 3/5	: sys/syscall.h included	  [Jiri]
> > * 4/5	: no changes
> > * 5/5	: -lpthread added to link target  [Jiri]
> > * {1,5} : Changelog updated so scissor lines don't start at column 1
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Most are already in my perf/urgent branch.

- Arnaldo

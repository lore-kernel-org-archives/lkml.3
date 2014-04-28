Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaD1LpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbaD1LpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:45:17 -0400
Date: Mon, 28 Apr 2014 13:20:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] perf tests: Factor out fake_setup_machine()
Message-ID: <20140428112003.GB18628@krava.brq.redhat.com>
References: <1398396494-12811-1-git-send-email-namhyung@kernel.org>
 <20140425122734.GD4116@krava.brq.redhat.com>
 <871twiqq6p.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871twiqq6p.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 08:59:42AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Fri, 25 Apr 2014 14:27:34 +0200, Jiri Olsa wrote:
> > On Fri, Apr 25, 2014 at 12:28:13PM +0900, Namhyung Kim wrote:
> >> The fake_setup_machine() is for setting up a environment for testing
> >> various hists operations.  As it'll be used for other test cases it'd
> >> better factoring it out.
> >
> > looks like print_hists could be in hists_common.c as well..
> > within another update ;-)
> 
> The difference is that one in hists_link.c is working on the input tree
> while one in hists_filter.c is working on the output tree.

I see, missed that.. ok

thanks,
jirka

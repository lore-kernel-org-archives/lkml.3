Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3GHPt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:49:56 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:55154 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3GHPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:49:55 -0400
Date: Mon, 8 Jul 2013 11:55:33 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Jiri Olsa <jolsa@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
In-Reply-To: <20130708135048.GA1069@krava.brq.redhat.com>
Message-ID: <alpine.DEB.2.10.1307081154110.2449@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
 <20130703074929.GE23916@twins.programming.kicks-ass.net> <20130708135048.GA1069@krava.brq.redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jul 2013, Jiri Olsa wrote:

> On Wed, Jul 03, 2013 at 09:49:29AM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 02, 2013 at 11:15:59PM -0400, Vince Weaver wrote:
> need to check if that does not break anything else ;-)

I've applied your patch to stock 3.10 and am now unable to hang my Core2 
machine that was exhibiting the problem in the first place.

I've also run the various test suites I have and haven't seen any 
regressions from the patch.

Vince

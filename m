Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaJBP76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:59:58 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:64795 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaJBP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:59:56 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 2 Oct 2014 12:06:11 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Cong Wang <cwang@twopensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <alpine.DEB.2.11.1410021106150.11281@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1410021205220.3801@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu> <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu> <20140910143306.GD4783@worktop.ger.corp.intel.com> <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu>
 <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com> <542789E5.7090805@oracle.com> <20140930172308.GI4241@worktop.programming.kicks-ass.net> <542BE27B.6040006@oracle.com>
 <alpine.DEB.2.11.1410021106150.11281@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2014, Vince Weaver wrote:

> It looks like this is easily reproducible (just wedged the machine again)
> so let me check back after testing the patch.

no, can still wedge the machine even with this patch applied.

Will try messing with ftrace to see if I can figure out what's going on.

Vince


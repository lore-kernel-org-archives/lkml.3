Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbaDIVeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:34:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53601 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaDIVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:34:06 -0400
Subject: Re: [RFC PATCH v2 0/6] uprobes/x86: fix the reprel jmp/call
 handling
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140409194401.GA5854@redhat.com>
References: <20140404185038.GA14679@redhat.com>
	 <20140404193226.GA23092@redhat.com>
	 <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com>
	 <20140406201524.GA32694@redhat.com>  <20140409194401.GA5854@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Apr 2014 14:34:00 -0700
Message-ID: <1397079240.5261.27.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040921-9332-0000-0000-00000074909D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 21:44 +0200, Oleg Nesterov wrote:
> On 04/06, Oleg Nesterov wrote:
> >
> > OK. Please see the RFC changes. Obviously not for inclusion yet. And
> > totally untested, except I verified that the test-case from 4/6 works.
> 
> Still not really tested, but seems to work.
> 
> Please see v2. All changes are minor except the s/ENOSYS/-ENOSYS/ fix.
> Please see the intediff below. I also move "Introduce sizeof_long() ..."
> to the head of this series.
> 
> Jim, I am still thinking how I can improve the commenents in 4/6 as you
> asked me, and I obviously need to write the changelogs and change "ttt"
> prefix.
> 
> Will you agree with s/ttt/branch/ ?

Yes.

> 
> Do you think the code is fine in v2 ?

Yes, except for certain comments wrt call emulation.  See my reply about
patch #4 from a few minutes ago.

Once that's resolved, I consider all your patches so far
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
and
Acked-by: Jim Keniston <jkenisto@us.ibm.com>

> 
> Oleg.
...

Jim


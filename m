Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbaDIQuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:50:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898AbaDIQux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:50:53 -0400
Date: Wed, 9 Apr 2014 18:50:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] uprobes/x86: Emulate rip-relative conditional
	"near" jmp's
Message-ID: <20140409165042.GE18486@redhat.com>
References: <20140406201524.GA32694@redhat.com> <20140406201636.GA521@redhat.com> <20140407142823.GB8881@redhat.com> <1396998435.5056.74.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396998435.5056.74.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Jim Keniston wrote:
>
> On Mon, 2014-04-07 at 16:28 +0200, Oleg Nesterov wrote:
> >
> > It seems that 16bit condi jmp is just 0x0f + short_jump_opc_plus_0x10.
>
> Yes, but the code could use a comment to that effect.  See below.

OK, will do.

> Searching for "jump" in the AMD manual, I see that there are 3 other
> instructions that are essentially conditional branches: loop,
> loope/loopz, and loopne/loopnz.

Yes, I know, Denys already informed me privately ;)

> The offset is always 8 bits.

And thus this series can ignore them. But as I already said, I'll try
to support them later just for completeness.

> BTW, patches 2 and 3 look fine to me.

Great!

Thanks again Jim for your helpful review.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaDDOUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:20:42 -0400
Received: from one.firstfloor.org ([193.170.194.197]:51761 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaDDOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:20:40 -0400
Date: Fri, 4 Apr 2014 16:20:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg KH <gregkh@linuxfoundation.org>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ktap and ebpf integration
Message-ID: <20140404142038.GR22728@two.firstfloor.org>
References: <CAGdX0WEeZJ9hxq1y-gmGC=kdtU0ecLbs5gVYb_8ZE6sOW_PPvg@mail.gmail.com>
 <CAMEtUuyQZo6fSMTZ5XKPfPBdjR13916Rd3=z5dip3N_WOzvr6Q@mail.gmail.com>
 <CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WFm2wccs30q1=eduLdzjAjfxz-6oL-zGvumY6BigQ-a4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, I think there will don't have any necessary to upstream
> ktap any more, I still enjoy the simplicity and flexibility given

Not sure how you got to that conclusion.

You were asked to evaluate if EBPF is an alternative
for ktap. It looks like the answer is no. So the original KTAP VM design
is back on the table. You can continue pursuing to merge that.
No reason to give up.

BTW I agree that EBPF won't work for ktap. The models
(static vs dynamic typing etc.) are just too different.
But it's good that it was studied in detail.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

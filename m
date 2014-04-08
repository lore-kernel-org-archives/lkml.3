Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbaDHTeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:34:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:16937 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932159AbaDHTeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:34:14 -0400
Date: Tue, 8 Apr 2014 15:34:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Subject: Re: [RFC PATCH] time: Fix truncation in jiffies_to_usecs()
Message-ID: <20140408153412.0648fb96@gandalf.local.home>
In-Reply-To: <20140408185609.GA14519@localhost.localdomain>
References: <0214020@agluck-desk.sc.intel.com>
	<CA+8MBb+E_zT47qu4a6pqQWArrhs0gv1W=JKoy252_-Uw6HfbkA@mail.gmail.com>
	<20140408174946.GA11121@localhost.localdomain>
	<20140408141543.2de9449d@gandalf.local.home>
	<20140408185609.GA14519@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 20:56:13 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:
 
> So it may indeed be a better idea to first create a standalone jiffies_to_nsecs().
> It can then be used to deprecate and replace most (if not all) calls to jiffies_to_usecs()
> altogether. Just the conversion must be made one by one to make sure that users can
> handle that.
> 
> Of course a big fat comment on jiffies_to_usecs() to describe that it's unsafe
> and deprecated would help a bit.

Sure, sounds like a plan.

-- Steve

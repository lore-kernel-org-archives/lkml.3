Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaJVBwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:52:17 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59224 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaJVBwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:52:15 -0400
Message-ID: <1413942678.17435.11.camel@debian>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 22 Oct 2014 09:51:18 +0800
In-Reply-To: <20141021202840.GD4420@pd.tnic>
References: <1412070991.16556.12.camel@cyc> <20140930100940.GD4639@pd.tnic>
	 <1412138102.21488.20.camel@debian> <20141002131206.GA16452@pd.tnic>
	 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
	 <5435B206.60402@amd.com> <20141008225750.GH16892@pd.tnic>
	 <20141009165339.GA11360@arav-dinar> <20141009173529.GC17647@pd.tnic>
	 <5436DB72.1090507@amd.com> <20141021202840.GD4420@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 22:28 +0200, Borislav Petkov wrote:
> On Thu, Oct 09, 2014 at 02:01:06PM -0500, Aravind Gopalakrishnan wrote:
> > I actually agree with this approach. So no argument:)
> 
> Ok, thanks, here's a patch.
> 
> Btw, I'm pushing the whole queue to a ras-for-3.19 branch at
> https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git if you'd like to
> take a look and see whether we haven't forgotten anything before I send
> it to tip guys.
> 
Hi Boris,

Can you check the following link? The link contains my reply about 
"x86, MCE, AMD: Move invariant code out from loop body". The reply
was sent to you on October 7, but until now, there aren't any comments
from you!

https://lkml.org/lkml/2014/10/7/84

Thanks!
cyc


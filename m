Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3LPR5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:57:04 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:43882 "EHLO
	smtp5.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3LPR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:57:02 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp5.sgsi.ucl.ac.be 98F3711E46F
Date: Mon, 16 Dec 2013 18:56:51 +0100
From: Christoph Paasch <christoph.paasch@uclouvain.be>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Ian Fang <ianfang.cn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: BUG: crashkernel does not boot upon crash from sysrq-trigger
Message-ID: <20131216175651.GA5048@cpaasch-mac>
References: <20131216113510.GA5211@cpaasch-mac>
 <CAM_iQpUTTNbJLCNDem0xOCGW7XWctEyQ3H2w-1=y0HkhJ4uWhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUTTNbJLCNDem0xOCGW7XWctEyQ3H2w-1=y0HkhJ4uWhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 98F3711E46F.A1201
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/13 - 09:36:52, Cong Wang wrote:
> On Mon, Dec 16, 2013 at 3:35 AM, Christoph Paasch
> <christoph.paasch@uclouvain.be> wrote:
> > Hello,
> >
> > since 3.5, my crashkernel does not boot anymore when triggering an oops with
> > /proc/sysrq-trigger on my HP Elitebook 8540p.
> >
> > I bisected it down to 722bc6b16771ed8 (x86/mm: Fix the size calculation of
> > mapping tables).
> >
> 
> It has been reverted in upstream.

Oh, then something else is causing my bug again, because I tried v3.13-rc3
to see if it has been fixed upstream. And, my Ubuntu runs on v3.11, where
the crashkernel does not work either.

My bisect ended up on 722bc6b16771ed8 because I started bisecting between v3.2
(good) and v3.5 (bad).

So, then I will make again a bisect between v3.7 and v3.11.


Thanks,
Christoph

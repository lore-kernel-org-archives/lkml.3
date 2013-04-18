Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936364Ab3DRQin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:38:43 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:40179
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933132Ab3DRQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:38:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Ic540Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLGM8B-01-6YL-02
X-M-MSG: 
Date: Thu, 18 Apr 2013 11:38:32 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] perf: Add support for hardware breakpoint address
 masks
Message-ID: <20130418163832.GA14253@jshin-Toonie>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
 <20130415172803.GA18406@jshin-Toonie>
 <20130416093620.GH9569@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130416093620.GH9569@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:36:20AM +0200, Ingo Molnar wrote:
> 
> * Jacob Shin <jacob.shin@amd.com> wrote:
> 
> > On Tue, Apr 09, 2013 at 12:21:48PM -0500, Jacob Shin wrote:
> > > The following patchset adds address masks to existing perf hardware
> > > breakpoint mechanism to allow trapping on an address range (currently
> > > only single address) on supported architectures.
> > > 
> > > perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> > > beyond) is provided, and perf tool has been extended to do:
> > > 
> > >   $ perf stat -e mem:0x1000:w:0xf a.out
> > >                               ^^^
> > >                               "don't care" bit mask
> > > 
> > >   which will count writes to [0x1000 ~ 0x1010)
> > 
> > Ping .. Ingo?
> 
> breakpoint patches usually come to me through (or with the acks of) Frederic 
> and/or Oleg.
> 
> Frederic, Oleg, mind having a look?

Hi Frederic, Oleg. Could one of you take a look over this patchset
when you get the chance? Thank you in advance for taking the time!


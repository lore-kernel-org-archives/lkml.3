Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3FTKbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:31:01 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37463 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644Ab3FTKa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:30:58 -0400
Date: Thu, 20 Jun 2013 12:30:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 0/2] x86/microcode/amd: early loading fixes
Message-ID: <20130620103053.GA9609@gmail.com>
References: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
 <20130612193119.GB15934@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612193119.GB15934@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacob Shin <jacob.shin@amd.com> wrote:

> On Fri, Jun 07, 2013 at 09:22:18PM -0500, Jacob Shin wrote:
> > This patchset addreses two problems with early loading on AMD.
> > 
> > First, feedback from Yinghai that find_ucode_in_initrd() should be
> > marked __init:
> >   https://lkml.org/lkml/2013/6/4/695
> > 
> > And second, feedback from Henrique that Intel early loading supports
> > multiple microcode firmware concatenated together, whereas the current
> > AMD implementation lacks this support:
> >   https://lkml.org/lkml/2013/5/31/4
> > 
> > V3:
> > * style fix -- reduce multiple if statements into a single one
> 
> Hi hpa or Yinghai, just wondering if you had the chance to look at this
> V3 yet.

It appears Peter applied v2 to tip:x86/microcode two days before you sent 
v3 - please send any changes in v3 as delta patches.

Thanks,

	Ingo

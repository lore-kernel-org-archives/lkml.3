Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaJXKcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:32:08 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48033 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJXKcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:32:07 -0400
Date: Fri, 24 Oct 2014 11:31:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Z Lim <zlim.lnx@gmail.com>
Cc: Andre Przywara <Andre.Przywara@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BPF crash with 3.18-rc1 on arm64 Juno hardware
Message-ID: <20141024103158.GB1955@localhost>
References: <54493433.4090703@arm.com>
 <CABg9mcu0-AFNNOn+C4kbS7_rWqc-6WXZTyKUJYz6rA7-8OBqZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABg9mcu0-AFNNOn+C4kbS7_rWqc-6WXZTyKUJYz6rA7-8OBqZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 06:23:49PM +0100, Z Lim wrote:
> On Thu, Oct 23, 2014 at 10:00 AM, Andre Przywara <andre.przywara@arm.com> wrote:
> > I see a crash with 3.18-rc1 on a Juno board related to bpf_jit (see dump
> > below). Userland tries to carry on afterwards, but eventually hangs in
> > RCU stalls.
> > The kernel has just CONFIG_BPF_JIT enabled, I guess Ubuntu enables this
> > automatically if detected.
> 
> When net-next and arm64-next merged in mainline, a silent failure is
> introduced due to new enhancements in net/bpf.
> This was actually uncovered before 3.18 merge window, and Daniel's
> patch to fix this was discussed here [1].
> I see that Catalin has queued up this patch in fixes/core [2].

Indeed. Pull request to Linus will go out later today.

-- 
Catalin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965561AbaGPQWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:22:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40891 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965488AbaGPQW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:22:28 -0400
Date: Wed, 16 Jul 2014 17:21:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Jiang Liu <liuj97@gmail.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFCv3 00/14] arm64: eBPF JIT compiler
Message-ID: <20140716162146.GV29414@arm.com>
References: <1405405512-4423-1-git-send-email-zlim.lnx@gmail.com>
 <20140716104153.GL29414@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716104153.GL29414@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 11:41:53AM +0100, Will Deacon wrote:
> On Tue, Jul 15, 2014 at 07:24:58AM +0100, Zi Shen Lim wrote:
> > This series implements eBPF JIT compiler for arm64.
> > See [14/14] for change log.
> > 
> > Patches [1-13/14] implement code generation functions.
> 
> Nice work, I'll take a look. Thanks!

... and it all looks pretty damn good to me. I gave you a few in-line
comments but, rather than repeat myself for each patch, my main two gripes
were:

  - The use of BUG_ON all over the place

  - Explicit limit checks which could be done with masks

If you address those, this stuff looks pretty much ready to go from my
perspective. Do you have a branch somewhere I can play with please?

Cheers,

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3GIBA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:00:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3GIBAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:00:24 -0400
Subject: Re: [PATCH 0/2] powerpc: allow kvm to use kerel debug framework
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com>
Date: Tue, 9 Jul 2013 03:00:16 +0200
Cc: <linuxppc-dev@lists.ozlabs.org>, <mikey@neuling.org>,
        <benh@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C4D71A1A-3D5B-4C9C-A26B-9EAFFD9D87C5@suse.de>
References: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com>
To: Bharat Bhushan <r65777@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04.07.2013, at 08:15, Bharat Bhushan wrote:

> From: Bharat Bhushan <bharat.bhushan@freescale.com>
> 
> This patchset moves the debug registers in a structure, which allows
> kvm to use same structure for debug emulation.
> 
> Note: Earilier a patchset "https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-June/108132.html"
> was sent which is a bunch of six patches. That patchset is divided into two parts:
> 	1) powerpc specific changes (These 2 patches are actually have those changes)
> 	2) KVM specific changes (will send separate patch on agraf repository)

Mikey, if you like those could you please apply the into a topic branch and get that one merged with Ben? I'd also pull it into my tree then.


Alex

> 
> Bharat Bhushan (2):
>  powerpc: remove unnecessary line continuations
>  powerpc: move debug registers in a structure
> 
> arch/powerpc/include/asm/processor.h |   38 +++++----
> arch/powerpc/include/asm/reg_booke.h |    8 +-
> arch/powerpc/kernel/asm-offsets.c    |    2 +-
> arch/powerpc/kernel/process.c        |   42 +++++-----
> arch/powerpc/kernel/ptrace.c         |  154 +++++++++++++++++-----------------
> arch/powerpc/kernel/ptrace32.c       |    2 +-
> arch/powerpc/kernel/signal_32.c      |    6 +-
> arch/powerpc/kernel/traps.c          |   35 ++++----
> 8 files changed, 147 insertions(+), 140 deletions(-)
> 
> 


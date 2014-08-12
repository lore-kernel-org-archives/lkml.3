Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaHLJ0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:26:48 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47654 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751457AbaHLJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:26:47 -0400
Date: Tue, 12 Aug 2014 10:26:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sadasivan Shaiju <sshaiju@mvista.com>
Cc: Catalin.Marinas@arm.com, linux-kernel@vger.kernel.org,
        shaiju_sada@yahoo.com
Subject: Re: PATCH -RCU locking on last_VFP_context[cpu] in vfp_notifier
	[2.6.32]
Message-ID: <20140812092638.GG30401@n2100.arm.linux.org.uk>
References: <ad46c9518e35397c8f4d281a3f88d129@mail.gmail.com> <20140811224925.GE30401@n2100.arm.linux.org.uk> <dfaec2915a403865125b1e06c35386f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfaec2915a403865125b1e06c35386f9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 06:12:35PM -0700, Sadasivan Shaiju wrote:
> Hi  Russell,
> 
> Thanks  for  looking  into  the  issue.
> 
> This  issue  came  up  when  I  was  doing  econa (ARM)  board bringup
> for Montavista (cavium) .
> Following  was  the  bug  description .
> 
>   Using cge60-econa-cns3420-2.6.32_110928_1104937 the kernel failed to
> boot with
> the following error:
> 
> Internal error: Oops: 817 [#1] from cpu 1 PREEMPT SMP
> last sysfs file: /sys/devices/virtual/bdi/0:19/uevent
> Modules linked in: hmac ctr deflate
> CPU: 1    Tainted: G        W   (2.6.32.46.cge #1)
> PC is at vfp_notifier+0x48/0xbc
> LR is at vfp_notifier+0x44/0xbc
> pc : []    lr : []    psr: 60000013
> sp : aeee1d30  ip : aeee1d50  fp : aeee1d4c
> r10: af8d6460  r9 : ffffffff  r8 : af88c000
> r7 : a05ba584  r6 : af88c000  r5 : 00000001  r4 : 40000000
> r3 : 00000000  r2 : 00000000  r1 : 40000000  r0 : aeee0230
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 00c5787d  Table: 2eeec00a  DAC: 00000017
> Process grep (pid: 1710, stack limit = 0xaeee0270)
> Stack:  from cpu 1 (0xaeee1d30 to 0xaeee2000)
> 
> 
> During  the  bring up  I  used  to  intract  with   Catalin Marinas(
> Catalin.Marinas@arm.com)from  ARM  .  He  is  copied on the email .
> Catalin  has  pointed   out  the  following  patch  to  me ,  which
> solved  my problem .  I  just  want  to make  sure  the patch  goes to
> mainline kernel.

All you've done is re-quoted the same information you supplied in your
initial email with nothing new.  Therefore, you are wasting my time,
and I really can't be bothered with time wasters.

Since you seem to be totally incapable of analysing the problem
correctly, and I know very little about RT kernels, there's nothing
I can do here.  Sorry.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

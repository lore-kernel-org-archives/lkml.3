Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3FJGTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 02:19:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3FJGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 02:19:08 -0400
Date: Mon, 10 Jun 2013 09:18:49 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Daney <david.s.daney@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>, kvm@vger.kernel.org,
        linux-mips@linux-mips.org, ralf@linux-mips.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via
 the MIPS-VZ extensions.
Message-ID: <20130610061849.GX4725@redhat.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <51B26974.5000306@caviumnetworks.com>
 <20130609073115.GE4725@redhat.com>
 <51B50E87.2060501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B50E87.2060501@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 04:23:51PM -0700, David Daney wrote:
> On 06/09/2013 12:31 AM, Gleb Natapov wrote:
> >On Fri, Jun 07, 2013 at 04:15:00PM -0700, David Daney wrote:
> >>I should also add that I will shortly send patches for the kvm tool
> >>required to drive this VM as well as a small set of patches that
> >>create a para-virtualized MIPS/Linux guest kernel.
> >>
> >>The idea is that because there is no standard SMP linux system, we
> >>create a standard para-virtualized system that uses a handful of
> >>hypercalls, but mostly just uses virtio devices.  It has no emulated
> >>real hardware (no 8250 UART, no emulated legacy anything...)
> >>
> >Virtualization is useful for running legacy code. Why dismiss support
> >for non pv guests so easily?
> 
> Just because we create standard PV system devices, doesn't preclude
> emulating real hardware.  In fact Sanjay Lal's work includes QEMU
> support for doing just this for a MIPS malta board.  I just wanted a
> very simple system I could implement with the kvm tool in a couple
> of days, so that is what I initially did.
> 
That makes sense. From your wording I misunderstood that there is something
in proposed patches that requires PV to run a guest.

--
			Gleb.

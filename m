Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3FJLRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:17:06 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:49134 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3FJLRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:17:04 -0400
Date: Mon, 10 Jun 2013 13:16:42 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Daney <david.s.daney@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>, kvm@vger.kernel.org,
        linux-mips@linux-mips.org, Sanjay Lal <sanjayl@kymasys.com>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via
 the MIPS-VZ extensions.
Message-ID: <20130610111642.GF28380@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <51B26974.5000306@caviumnetworks.com>
 <20130609073115.GE4725@redhat.com>
 <51B50E87.2060501@gmail.com>
 <alpine.LFD.2.03.1306100030210.18329@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1306100030210.18329@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 12:40:42AM +0100, Maciej W. Rozycki wrote:

> > >   How different MIPS SMP systems are?
> > 
> > o Old SGI heavy metal (several different system architectures).
> > 
> > o Cavium OCTEON SMP SoCs.
> > 
> > o Broadcom (several flavors) SoCs
> > 
> > o Loongson
> 
> o Old DEC hardware (DECsystem 58x0, R3000-based).
> 
> o Malta-based MIPS Technologies CMP solutions (1004K, 1074K, interAptiv).

And more.  It's fairly accurate that MIPS SMP system tend to have little
of their system architecture in common beyond the underlying processor
architecture and everything else should be treated as a lucky coincidence.

  Ralf

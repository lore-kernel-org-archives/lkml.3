Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbaIQOMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:12:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbaIQOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:12:35 -0400
Date: Wed, 17 Sep 2014 16:12:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>, Nadav Amit <namit@cs.technion.ac.il>,
        pbonzini@redhat.com, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/3] x86: structs for cpuid info in x86
Message-ID: <20140917141227.GN2840@worktop.localdomain>
References: <1410870160-28845-1-git-send-email-namit@cs.technion.ac.il>
 <20140916132226.GA13726@gmail.com>
 <54189B3D.3040301@gmail.com>
 <20140917123710.GF2704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917123710.GF2704@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 02:37:10PM +0200, Ingo Molnar wrote:
> If hpa, tglx or Linus objects I'll yield to that objection 
> though.
> 
> Opinions, objections?

They generally look fine to me. I appreciate the bitfields for
readability. I often use the same when having to deal with hardware
bitfields. See for example the cpuid10_a?x unions in asm/perf_event.h

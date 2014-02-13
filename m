Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaBMS0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:26:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51127 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaBMS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:26:13 -0500
Date: Thu, 13 Feb 2014 19:26:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140213182605.GC14089@laptop.programming.kicks-ass.net>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
 <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213173852.GH6835@laptop.programming.kicks-ass.net>
 <52FD090C.7010408@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FD090C.7010408@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 07:03:56PM +0100, Stefan Bader wrote:
> Yeah... not sure the interleaved source helps or not ...

It did, thanks!

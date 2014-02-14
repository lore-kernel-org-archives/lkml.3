Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaBNRWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:22:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51051 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaBNRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:22:16 -0500
Date: Fri, 14 Feb 2014 18:21:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140214172157.GJ6835@laptop.programming.kicks-ass.net>
References: <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213173852.GH6835@laptop.programming.kicks-ass.net>
 <52FD090C.7010408@canonical.com>
 <20140213182605.GC14089@laptop.programming.kicks-ass.net>
 <20140214133428.GB26356@pd.tnic>
 <52FE2709.3050505@canonical.com>
 <20140214144700.GC26356@pd.tnic>
 <52FE4C28.1080500@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FE4C28.1080500@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 06:02:32PM +0100, Stefan Bader wrote:
> One thing I likely should do is to reinstall the exact same laptop with 64bit
> kernel and userspace... maybe only 64bit kernel first... and make sure on my
> side that this does not show up on 64bit, too. I took the word of reporters for
> that (and the impression that otherwise many more people would have complained).

Yeha, I'm going to try and install some 32bit userspace on a usb
harddisk I've got and see if I can boot my Core2 laptop from that to try
and reproduce.

But all that is probably going to be Monday :/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3BPIld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:41:33 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:44777 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3BPIlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:41:32 -0500
Date: Sat, 16 Feb 2013 09:41:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Maynard Johnson <mpjohn@us.ibm.com>,
        Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v7 07/18] perf: add generic memory sampling interface
Message-ID: <20130216084127.GC18953@gmail.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <1359040242-8269-8-git-send-email-eranian@google.com>
 <20130125090158.GB31478@gmail.com>
 <20130215194622.GA6396@us.ibm.com>
 <1360982707.22260.79.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360982707.22260.79.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2013-02-15 at 11:46 -0800, Sukadev Bhattiprolu wrote:
> > 
> > POWER could use an additional field:
> > 
> >                         mem_deratmiss:1
> 
> If you want to make that field more "generic" make it 
> "lvl1_tlb_miss", ie, a miss in the internal "level 1" TLB 
> which is the smallest/fastest TLB level in the load/store 
> unit.

I'd also suggest adding spare bits generously, if this is a 
fixed width ABI component - or a size field.

Thanks,

	Ingo

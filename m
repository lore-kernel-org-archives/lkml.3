Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab3JNUZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:25:51 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57608 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab3JNUZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:25:49 -0400
Date: Mon, 14 Oct 2013 16:25:28 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131014202528.GG26880@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <87siw4xy9i.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87siw4xy9i.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 09:38:33PM -0700, Andi Kleen wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > Sébastien Dugué reported to me that devices implementing ipoib (which don't have
> > checksum offload hardware were spending a significant amount of time computing
> 
> Must be an odd workload, most TCP/UDP workloads do copy-checksum
> anyways. I would rather investigate why that doesn't work.
> 
FWIW, the reporter was reporting this using an IP over Infiniband network.
Neil

> That said the change looks reasonable, but may not fix the root cause.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
> 

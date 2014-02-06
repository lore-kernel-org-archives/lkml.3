Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaBFWb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:31:59 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65406 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaBFWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:31:58 -0500
Date: Thu, 6 Feb 2014 14:31:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [patch 1/4] x86, apic: Only use default_wait_for_init_deassert
In-Reply-To: <87txcc57y2.fsf@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1402061430420.29446@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com> <87txcc57y2.fsf@tassilo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Andi Kleen wrote:

> > es7000_wait_for_init_deassert() is functionally equivalent to 
> > default_wait_for_init_deassert(), so remove the duplicate code and use
> > only a single function.
> 
> It would surprise me if anyone uses the es7000 anymore -- it may be
> reasonable to just deprecate the complete port.
> 

How do we usually do that?  Do we add a big fat warning for anyone who is 
using it for a few releases or just yank support out entirely and see if 
we're surprised?

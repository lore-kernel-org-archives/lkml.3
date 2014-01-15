Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaAOBZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:25:19 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:43940 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaAOBZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:25:15 -0500
Date: Tue, 14 Jan 2014 17:25:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Grygorii Strashko <grygorii.strashko@ti.com>
cc: Fengguang Wu <fengguang.wu@intel.com>, santosh.shilimkar@ti.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/mm: memblock: switch to use NUMA_NO_NODE
In-Reply-To: <1389198198-31027-1-git-send-email-grygorii.strashko@ti.com>
Message-ID: <alpine.DEB.2.02.1401141724480.32645@chino.kir.corp.google.com>
References: <20140107022559.GE14055@localhost> <1389198198-31027-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, Grygorii Strashko wrote:

> Update X86 code to use NUMA_NO_NODE instead of MAX_NUMNODES while
> calling memblock APIs, because memblock API is changed to use NUMA_NO_NODE and
> will produce warning during boot otherwise.
> 
> See:
>  https://lkml.org/lkml/2013/12/9/898
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for following through with this, Grygorii!

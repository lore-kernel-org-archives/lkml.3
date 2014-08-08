Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbaHHWDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:03:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57897 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419AbaHHWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:03:42 -0400
Date: Fri, 8 Aug 2014 15:03:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeremiah Mahler <jmmahler@gmail.com>
cc: Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] arch/x86/mm: sparse 'tlb_single_page_flush_ceiling'
 warning
In-Reply-To: <1407482671-23856-1-git-send-email-jmmahler@gmail.com>
Message-ID: <alpine.DEB.2.02.1408081503270.15603@chino.kir.corp.google.com>
References: <1407482671-23856-1-git-send-email-jmmahler@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Jeremiah Mahler wrote:

> A sparse warning is generated about 'tlb_single_page_flush_ceiling'
> not being declared.
> 
>   arch/x86/mm/tlb.c:177:15: warning: symbol
>   'tlb_single_page_flush_ceiling' was not declared. Should it be static?
> 
> Since it isn't used anywhere outside this file, fix the warning by
> making it static.
> 
> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>

Seems like __read_mostly would also be in order?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbaBFVlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:41:13 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62691 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaBFVlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:41:12 -0500
Date: Thu, 6 Feb 2014 13:41:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [slub] WARNING: CPU: 1 PID: 1 at mm/slub.c:992
 deactivate_slab()
In-Reply-To: <alpine.DEB.2.02.1402051123520.5616@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1402061340360.12761@chino.kir.corp.google.com>
References: <20140205072558.GC9379@localhost> <alpine.DEB.2.02.1402050009200.7839@chino.kir.corp.google.com> <20140205112449.GB18849@localhost> <alpine.DEB.2.02.1402051123520.5616@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, David Rientjes wrote:

> Ah, that's because the patch didn't go through Pekka's slab tree but went 
> into -mm instead so we have to wait for another -mm.  However, the traces 
> from linux-next-20140204 that you provided indicate it's the same problem 
> and should be fixed with that patch, so let's wait for another mmotm to be 
> released.
> 

Ok, "mm/slub.c: list_lock may not be held in some circumstances" is in 
linux-next so let me know if this reproduces!

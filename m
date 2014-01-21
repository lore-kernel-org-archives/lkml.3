Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaAUG5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:57:54 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:47631 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaAUG5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:57:47 -0500
Date: Tue, 21 Jan 2014 07:57:38 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, liuj97@gmail.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com,
        tangchen@cn.fujitsu.com, yinghai@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/3] mm/nobootmem: Fix unused variable
Message-ID: <20140121075738.771d29b3@lilie>
In-Reply-To: <alpine.DEB.2.02.1401202214540.21729@chino.kir.corp.google.com>
References: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1390217559-14691-2-git-send-email-phacht@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1401202214540.21729@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012106-3548-0000-0000-000007C9C219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am Mon, 20 Jan 2014 22:16:33 -0800 (PST)
schrieb David Rientjes <rientjes@google.com>:

> Not sure why you don't just do a one line patch:
> 
> -	phys_addr_t size;
> +	phys_addr_t size __maybe_unused;
> to fix it.

Just because I did not know that __maybe_unused thing.

Discussion of this fix seems to be obsolete because Andrew already took
the patch int the form he suggested: One #ifdef in the function with a
basic block declaring size once inside.

Regards

Philipp


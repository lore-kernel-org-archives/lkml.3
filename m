Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaATL2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:28:47 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:43497 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaATL2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:28:44 -0500
Date: Mon, 20 Jan 2014 12:28:35 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, liuj97@gmail.com, santosh.shilimkar@ti.com,
        grygorii.strashko@ti.com, iamjoonsoo.kim@lge.com,
        robin.m.holt@gmail.com, yinghai@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/nobootmem: Fix unused variable
Message-ID: <20140120122835.35e6d366@lilie>
In-Reply-To: <20140117133831.2a9306a03f9c6174ff096e48@linux-foundation.org>
References: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
	<20140117133831.2a9306a03f9c6174ff096e48@linux-foundation.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012011-6892-0000-0000-000007846848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am Fri, 17 Jan 2014 13:38:31 -0800
schrieb Andrew Morton <akpm@linux-foundation.org>:

> Yes, that is a bit of an eyesore.  We often approach the problem this
> way, which is nicer:

> [ ... ]
> #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> 	{
> 		phys_addr_t size;
> 
> 		[ ... ]
>	}
> #endif

This is a very nice idea! I have updated my fix. This leads to a V5
patch series (which I will post now) because the following to patches
had to be slightly updated
to fit on top of the fix.

Kind regards

Philipp


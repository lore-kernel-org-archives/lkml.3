Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936157Ab3DPUQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:16:45 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41995 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934781Ab3DPUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:16:44 -0400
Date: Tue, 16 Apr 2013 13:16:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <20130416110009.GA2664@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
References: <20130416110009.GA2664@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013, Han Pingtian wrote:

> Hi list,
> 
> On a power7 system, we have installed 3.9-rc7 and crash 6.1.6. If I run
> something like "make -j 64" to compile linux kernel from source, sooner
> or latter, oom-killer will be triggered. Before that, when I trying to
> analyse the live system with crash, some processes' %MEM and RSS looks
> too big:
> 

Do you have the oom killer log from /var/log/messages with 
/proc/sys/vm/oom_dump_tasks enabled?  Have you tried to reproduce this 
issue with CONFIG_DEBUG_VM and CONFIG_DEBUG_PAGEALLOC enabled (you may 
even want to consider CONFIG_KMEMLEAK)?

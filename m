Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3BKQRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:17:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34522 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3BKQRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:17:22 -0500
Message-ID: <511919C7.5080502@infradead.org>
Date: Mon, 11 Feb 2013 08:18:15 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: linux-next: Tree for Feb 11 (intel_pstate.c)
References: <20130211184749.565d8e47788f8be8aec1591f@canb.auug.org.au>
In-Reply-To: <20130211184749.565d8e47788f8be8aec1591f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/13 23:47, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130208:
> 

on i386:

drivers/built-in.o: In function `intel_pstate_timer_func':
intel_pstate.c:(.text+0x4ce97e): undefined reference to `__udivdi3'
drivers/built-in.o: In function `intel_pstate_cpu_init':
intel_pstate.c:(.cpuinit.text+0x974): undefined reference to `__udivdi3'


-- 
~Randy

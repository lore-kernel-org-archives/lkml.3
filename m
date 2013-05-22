Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3EVWYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:24:49 -0400
Received: from ozlabs.org ([203.10.76.45]:36037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756616Ab3EVWYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:24:48 -0400
Date: Thu, 23 May 2013 08:23:57 +1000
From: Paul Mackerras <paulus@samba.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Power7: Make CPI stack events available in sysfs
Message-ID: <20130522222357.GC10945@iris.ozlabs.ibm.com>
References: <20130406164803.GA408@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406164803.GA408@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 09:48:03AM -0700, Sukadev Bhattiprolu wrote:
> >From bdeacf7175241f6c79b5b2be0fa6b20b0d0b7d1c Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Sat, 6 Apr 2013 08:48:26 -0700
> Subject: [PATCH] perf: Power7: Make CPI stack events available in sysfs
> 
> A set of Power7 events are often used for Cycles Per Instruction (CPI) stack
> analysis. Make these events available in sysfs (/sys/devices/cpu/events/) so
> they can be identified using their symbolic names:
> 
> 	perf stat -e 'cpu/PM_CMPLU_STALL_DCACHE_MISS/' /bin/ls
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Acked-by: Paul Mackerras <paulus@samba.org>

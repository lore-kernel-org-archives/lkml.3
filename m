Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3DOGPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:15:14 -0400
Received: from ozlabs.org ([203.10.76.45]:48528 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab3DOGPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:15:13 -0400
Date: Mon, 15 Apr 2013 16:15:09 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf: Power7: Make CPI stack events available in sysfs
Message-ID: <20130415061508.GD21147@concordia>
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
> From bdeacf7175241f6c79b5b2be0fa6b20b0d0b7d1c Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Sat, 6 Apr 2013 08:48:26 -0700
> Subject: [PATCH] perf: Power7: Make CPI stack events available in sysfs
> 
> A set of Power7 events are often used for Cycles Per Instruction (CPI) stack
> analysis. Make these events available in sysfs (/sys/devices/cpu/events/) so
> they can be identified using their symbolic names:
> 
> 	perf stat -e 'cpu/PM_CMPLU_STALL_DCACHE_MISS/' /bin/ls

Should we take these two via the powerpc tree? Or do you want to take
them Arnaldo?

cheers

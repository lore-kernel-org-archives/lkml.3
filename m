Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3EKWbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 18:31:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38439 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3EKWbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 18:31:40 -0400
Date: Sat, 11 May 2013 15:31:11 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] perf: Power7: Make CPI stack events available in sysfs
Message-ID: <20130511223111.GA30064@us.ibm.com>
References: <20130406164803.GA408@us.ibm.com>
 <20130415061508.GD21147@concordia>
 <20130422155505.GA26169@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422155505.GA26169@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051122-3620-0000-0000-0000026FEB46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| Michael Ellerman [michael@ellerman.id.au] wrote:
| | On Sat, Apr 06, 2013 at 09:48:03AM -0700, Sukadev Bhattiprolu wrote:
| | > From bdeacf7175241f6c79b5b2be0fa6b20b0d0b7d1c Mon Sep 17 00:00:00 2001
| | > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| | > Date: Sat, 6 Apr 2013 08:48:26 -0700
| | > Subject: [PATCH] perf: Power7: Make CPI stack events available in sysfs
| | > 
| | > A set of Power7 events are often used for Cycles Per Instruction (CPI) stack
| | > analysis. Make these events available in sysfs (/sys/devices/cpu/events/) so
| | > they can be identified using their symbolic names:
| | > 
| | > 	perf stat -e 'cpu/PM_CMPLU_STALL_DCACHE_MISS/' /bin/ls
| | 
| | Should we take these two via the powerpc tree? Or do you want to take
| | them Arnaldo?
| 
| I think it can go through powerpc tree since it is all arch-specific.
| 

Ben, Paul,

Any comments on this patch ?

	https://lkml.org/lkml/2013/4/6/169


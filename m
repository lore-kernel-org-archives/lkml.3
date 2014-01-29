Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaA2JAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:00:38 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61830 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaA2JAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:00:36 -0500
Date: Wed, 29 Jan 2014 01:00:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: compile error on linus git with ppc64
In-Reply-To: <1390985190.8524.54.camel@pasglop>
Message-ID: <alpine.DEB.2.02.1401290059490.12210@chino.kir.corp.google.com>
References: <20140128194311.00004303@unknown> <alpine.DEB.2.02.1401281953040.32278@chino.kir.corp.google.com> <1390985190.8524.54.camel@pasglop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, Benjamin Herrenschmidt wrote:

> I have a fix queued up in next, I'll ask Linus to pull tomorrow.
> 

Which fix?  From linux-next-20140129:

In file included from include/linux/spinlock.h:81:0,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/uapi/linux/timex.h:56,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:17,
                 from arch/powerpc/kernel/asm-offsets.c:17:
include/linux/spinlock_types.h:76:3: error: redefinition of typedef 'spinlock_t'
arch/powerpc/include/asm/pgtable-ppc64.h:563:25: note: previous declaration of 'spinlock_t' was here

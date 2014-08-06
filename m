Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaHFWoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:44:03 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61019 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaHFWoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:44:01 -0400
Date: Wed, 6 Aug 2014 15:43:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Bueso, Davidlohr" <davidlohr@hp.com>
Cc: David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FRV build failure with latest kernel
Message-ID: <20140806224356.GA5111@roeck-us.net>
References: <53E234DC.3050409@roeck-us.net>
 <279688AD5644A043870AAB6DBEFA9ED228280EE8@G5W2714.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <279688AD5644A043870AAB6DBEFA9ED228280EE8@G5W2714.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 08:37:14PM +0000, Bueso, Davidlohr wrote:
> 
> ________________________________________
> From: Guenter Roeck [linux@roeck-us.net]
> Sent: Wednesday, August 06, 2014 6:59 AM
> To: David Howells
> Cc: linux-kernel@vger.kernel.org; Bueso, Davidlohr
> Subject: FRV build failure with latest kernel
> 
> Building frv:defconfig ... failed
> --------------
> Error log:
> In file included from kernel/locking/mutex.c:28:0:
> kernel/locking/mcs_spinlock.h: In function 'mcs_spin_lock':
> kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of function 'cpu_relax_lowlatency' [-Werror=implicit-function-declaration]https://lkml.org/lkml/2014/8/5/442
> cc1: some warnings being treated as errors
> make[2]: *** [kernel/locking/mutex.o] Error 1
> 
> Due to commit 3a6bfbc91d (arch, locking: Ciao arch_mutex_cpu_relax()), which missed frv.
> 
> Yeah, I sent out the fix yesterday: https://lkml.org/lkml/2014/8/5/442
> 
Looks like Geert was faster than me, as usual ;-).

Thanks, hope this will make it upstream soon.

Guenter

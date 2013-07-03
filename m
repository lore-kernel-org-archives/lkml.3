Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3GCHdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:33:03 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:33789 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab3GCHdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:33:01 -0400
Date: Wed, 3 Jul 2013 09:32:49 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: fengguang.wu@intel.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [FMC] BUG: scheduling while atomic: swapper/1/0x10000002
Message-ID: <20130703073249.GA27110@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130703071540.GC25674@localhost>
References: <20130703071540.GC25674@localhost> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> I got the below dmesg and the first bad commit is
> 
> commit 4debfe409b6e550032bfef9733e9f6f7c5613617
> Author: Alessandro Rubini <rubini@gnudd.com>
> Date:   Tue Jun 18 23:48:07 2013 +0200
> 
>     FMC: add a char-device mezzanine driver

thank you for your report. I already got a problem report with
built-in FMC subsystem, but I couldn't reproduce it.  Actually, I use
drivers/fmc daily (I'm currently finalizing an ADC driver), but I run
the whole subsystem as module; it never happens in that case.

Thank you for bisecting, I'll take a deeper look as soon as possible
(hopefully today).  Meanwhile, please disable FMC or build as modules.

/alessandro

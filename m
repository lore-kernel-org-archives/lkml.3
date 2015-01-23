Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbbAWVAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:00:07 -0500
Received: from mail.kernel.org ([198.145.29.136]:55194 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbbAWVAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:00:04 -0500
Date: Fri, 23 Jan 2015 17:59:59 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: perf not capturing stack traces
Message-ID: <20150123205959.GD3073@kernel.org>
References: <20150123195128.GE26557@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123195128.GE26557@saruman.tx.rr.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 23, 2015 at 01:51:28PM -0600, Felipe Balbi escreveu:
> I'm using v3.19-rc5 on an ARM Cortex A9 board. Unfortunately, perf is
> not able to capture any stack traces even though I CONFIG_STACKTRACE,
> CONFIG_FRAME_POINTER and CONFIG_ARM_UNWIND all enabled.
> 
> I wonder if anybody else is facing similar issues.

Did it work with a previous kernel?

- Arnaldo

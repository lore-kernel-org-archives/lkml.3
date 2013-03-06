Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3CFWJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:09:51 -0500
Received: from ozlabs.org ([203.10.76.45]:33582 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab3CFWJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:09:50 -0500
From: Michael Neuling <mikey@neuling.org>
To: Philippe De Muyter <phdm@macqel.be>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: 3.9-rc1 powerpc ptrace.c: 'brk.len' is used uninitialized
In-reply-to: <20130306060058.GA3106@frolo.macqel>
References: <20130306060058.GA3106@frolo.macqel>
Comments: In-reply-to Philippe De Muyter <phdm@macqel.be>
   message dated "Wed, 06 Mar 2013 07:00:58 +0100."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Thu, 07 Mar 2013 09:09:48 +1100
Message-ID: <21084.1362607788@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> bisect tells me that since your commit 9422de3e953d0e60eb95f5430a9dd803eec1c6d7 
> "powerpc: Hardware breakpoints rewrite to handle non DABR breakpoint registers",
> compiling linux fails with :
> 
>   cc1: warnings being treated as errors
>   arch/powerpc/kernel/ptrace.c: In function 'arch_ptrace':
>   arch/powerpc/kernel/ptrace.c:1450: warning: 'brk.len' is used uninitialized in this function
>   arch/powerpc/kernel/ptrace.c:1352: note: 'brk.len' was declared here
> 
> could you look at that ?

Sure. 

How are you compiling this?  Is there a ppc defconfig that hits it?

Mikey

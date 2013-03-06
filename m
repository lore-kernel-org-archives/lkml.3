Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3CFGBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:01:07 -0500
Received: from smtp2.macqel.be ([194.78.208.39]:5316 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab3CFGBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:01:02 -0500
Date: Wed, 6 Mar 2013 07:00:58 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: 3.9-rc1 powerpc ptrace.c: 'brk.len' is used uninitialized
Message-ID: <20130306060058.GA3106@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

bisect tells me that since your commit 9422de3e953d0e60eb95f5430a9dd803eec1c6d7 
"powerpc: Hardware breakpoints rewrite to handle non DABR breakpoint registers",
compiling linux fails with :

  cc1: warnings being treated as errors
  arch/powerpc/kernel/ptrace.c: In function 'arch_ptrace':
  arch/powerpc/kernel/ptrace.c:1450: warning: 'brk.len' is used uninitialized in this function
  arch/powerpc/kernel/ptrace.c:1352: note: 'brk.len' was declared here

could you look at that ?

Thanks

Philippe

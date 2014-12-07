Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaLHBJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:09:11 -0500
Received: from ozlabs.org ([103.22.144.67]:43380 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbaLHBJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:09:09 -0500
Date: Mon, 8 Dec 2014 09:16:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: powerpc: kernel: sys_ppc32.c:  Remove unused
 function
Message-ID: <20141207221622.GA11372@iris.ozlabs.ibm.com>
References: <1417975014-13883-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417975014-13883-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 06:56:54PM +0100, Rickard Strandqvist wrote:
> Remove the function compat_sys_mmap2() that is not used anywhere.

It's referenced in 64-bit kernels from arch/powerpc/kernel/systbl.S,
via the SYS32ONLY(mmap2) line in arch/powerpc/include/asm/systbl.h.

Paul.

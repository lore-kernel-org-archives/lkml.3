Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaLVFC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 00:02:26 -0500
Received: from ozlabs.org ([103.22.144.67]:47655 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaLVFCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 00:02:25 -0500
In-Reply-To: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geoff Levand <geoff@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: cbe-oss-dev@lists.ozlabs.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: arch: powerpc: platforms: ps3: repository.c: Remove unused function
Message-Id: <20141222050223.39FA91400E7@ozlabs.org>
Date: Mon, 22 Dec 2014 16:02:23 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-20-12 at 15:00:01 UTC, Rickard Strandqvist wrote:
> Remove the function ps3_repository_write_highmem_info() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.

Actually it looks like everything under CONFIG_PS3_REPOSITORY_WRITE is unused,
and never was used.

We appreciate these sort of patches, but if you can dig a little deeper and
also work out why the code is unused that would be much more useful.

cheers

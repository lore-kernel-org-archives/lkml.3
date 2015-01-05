Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbbAEFEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 00:04:01 -0500
Received: from ozlabs.org ([103.22.144.67]:39608 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbAEFEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 00:04:00 -0500
Message-ID: <1420434223.3860.1.camel@ellerman.id.au>
Subject: Re: [PATCH 29/38] powerpc: drop _PAGE_FILE and pte_file()-related
 helpers
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Date: Mon, 05 Jan 2015 16:03:43 +1100
In-Reply-To: <1419423766-114457-30-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1419423766-114457-30-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 14:22 +0200, Kirill A. Shutemov wrote:
> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  arch/powerpc/include/asm/pgtable-ppc32.h | 9 ++-------
>  arch/powerpc/include/asm/pgtable-ppc64.h | 5 +----
>  arch/powerpc/include/asm/pgtable.h       | 1 -
>  arch/powerpc/include/asm/pte-40x.h       | 1 -
>  arch/powerpc/include/asm/pte-44x.h       | 5 -----
>  arch/powerpc/include/asm/pte-8xx.h       | 1 -
>  arch/powerpc/include/asm/pte-book3e.h    | 1 -
>  arch/powerpc/include/asm/pte-fsl-booke.h | 3 ---
>  arch/powerpc/include/asm/pte-hash32.h    | 1 -
>  arch/powerpc/include/asm/pte-hash64.h    | 1 -
>  arch/powerpc/mm/pgtable_64.c             | 2 +-
>  11 files changed, 4 insertions(+), 26 deletions(-)

These bits look fine to me.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers



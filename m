Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaLYKVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 05:21:11 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:49840 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaLYKVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 05:21:08 -0500
Date: Thu, 25 Dec 2014 12:18:16 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Hugh Dickins <hughd@google.com>, Linux MM <linux-mm@kvack.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 24/38] mips: drop _PAGE_FILE and pte_file()-related
 helpers
Message-ID: <20141225101816.GA6695@node.dhcp.inet.fi>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1419423766-114457-25-git-send-email-kirill.shutemov@linux.intel.com>
 <CAMuHMdWKNEeb3uOJ+gct06mbuD4RqP7F32FhMtax-tG7d_Yj1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWKNEeb3uOJ+gct06mbuD4RqP7F32FhMtax-tG7d_Yj1g@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 11:08:11AM +0100, Geert Uytterhoeven wrote:
> On Wed, Dec 24, 2014 at 1:22 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > We've replaced remap_file_pages(2) implementation with emulation.
> > Nobody creates non-linear mapping anymore.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > ---
> >  arch/m68k/include/asm/mcf_pgtable.h  |  6 ++----
> 
> This contains a change to an m68k header file.
> The same file was modified in the m68k part of the series, but this change was
> not included?

Oops. I've folded this into wrong patch. Will fix.

-- 
 Kirill A. Shutemov

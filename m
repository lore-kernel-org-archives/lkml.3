Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaEZNrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:47:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:46277 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaEZNrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:47:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,913,1392192000"; 
   d="scan'208";a="545061895"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jeff Smith <jsmith.lkml@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <CAAih0NhTXOb+Hj+u+0QLrADxyOYc-EwHDCx5+1Fq7wiJsaY=_Q@mail.gmail.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <CAAih0NjpHKc11JfG3MOnvisXesg-LoaS0Cx1rOA5ggDEHNfY6g@mail.gmail.com>
 <20140526094240.B5508E009B@blue.fi.intel.com>
 <CAAih0Nght-5k6mp-_jc+GipxPfxPYdCEabH_8M2QMkM_B5FPWw@mail.gmail.com>
 <53834310.8060808@redhat.com>
 <CAAih0NhTXOb+Hj+u+0QLrADxyOYc-EwHDCx5+1Fq7wiJsaY=_Q@mail.gmail.com>
Subject: Re: remap_file_pages() use
Content-Transfer-Encoding: 7bit
Message-Id: <20140526134718.0AAC7E009B@blue.fi.intel.com>
Date: Mon, 26 May 2014 16:47:18 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Smith wrote:
> OK, I misinterpreted "the overlapped part of the mapping(s) will be
> discarded" as discarding the -new- mappings. My objections about
> needing a replacement for remap_file_pages() are gone, but my concerns
> about existing code still remain.

As I said, emulation will be there for long time. With warning in dmesg.
The emulation is interface-compatible, but slower in some cases (not
your's).

-- 
 Kirill A. Shutemov

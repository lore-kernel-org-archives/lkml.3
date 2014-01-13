Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaAMXdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:33:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36066 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751994AbaAMXdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:33:37 -0500
Date: Mon, 13 Jan 2014 23:33:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mm: nobootmem: avoid type warning about alignment value
Message-ID: <20140113233326.GG15937@n2100.arm.linux.org.uk>
References: <529217C7.6030304@cogentembedded.com> <52935762.1080409@ti.com> <20131209165044.cf7de2edb8f4205d5ac02ab0@linux-foundation.org> <20131210005454.GX4360@n2100.arm.linux.org.uk> <52A66826.7060204@ti.com> <20140112105958.GA9791@n2100.arm.linux.org.uk> <52D2B7C8.4060103@ti.com> <20140113123733.GU15937@n2100.arm.linux.org.uk> <52D3F7E0.3030206@ti.com> <20140113153128.6aaffb9af111ba75a7abd4db@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113153128.6aaffb9af111ba75a7abd4db@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 03:31:28PM -0800, Andrew Morton wrote:
> On Mon, 13 Jan 2014 09:27:44 -0500 Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> 
> > > It seems to me to be absolutely silly to have code introduce a warning
> > > yet push the fix for the warning via a completely different tree...
> > > 
> > I mixed it up. Sorry. Some how I thought there was some other build
> > configuration thrown the same warning with memblock series and hence
> > suggested the patch to go via Andrew's tree.
> 
> Yes, I too had assumed that the warning was caused by the bootmem
> patches in -mm.
> 
> But it in fact occurs in Linus's current tree.  I'll drop
> mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch
> and I'll assume that rmk will fix this up at an appropriate time.

Thanks.  I'll apply my version and then I can pull Santosh's nobootmem
changes (which I've had a couple of times already) without adding to
the warnings.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

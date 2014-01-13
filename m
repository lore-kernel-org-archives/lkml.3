Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaAMXbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:31:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaAMXb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:31:29 -0500
Date: Mon, 13 Jan 2014 15:31:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mm: nobootmem: avoid type warning about alignment value
Message-Id: <20140113153128.6aaffb9af111ba75a7abd4db@linux-foundation.org>
In-Reply-To: <52D3F7E0.3030206@ti.com>
References: <1385249326-9089-1-git-send-email-santosh.shilimkar@ti.com>
	<529217C7.6030304@cogentembedded.com>
	<52935762.1080409@ti.com>
	<20131209165044.cf7de2edb8f4205d5ac02ab0@linux-foundation.org>
	<20131210005454.GX4360@n2100.arm.linux.org.uk>
	<52A66826.7060204@ti.com>
	<20140112105958.GA9791@n2100.arm.linux.org.uk>
	<52D2B7C8.4060103@ti.com>
	<20140113123733.GU15937@n2100.arm.linux.org.uk>
	<52D3F7E0.3030206@ti.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 09:27:44 -0500 Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> > It seems to me to be absolutely silly to have code introduce a warning
> > yet push the fix for the warning via a completely different tree...
> > 
> I mixed it up. Sorry. Some how I thought there was some other build
> configuration thrown the same warning with memblock series and hence
> suggested the patch to go via Andrew's tree.

Yes, I too had assumed that the warning was caused by the bootmem
patches in -mm.

But it in fact occurs in Linus's current tree.  I'll drop
mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch
and I'll assume that rmk will fix this up at an appropriate time.

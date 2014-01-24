Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaAXUR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:17:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaAXUR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:17:27 -0500
Date: Fri, 24 Jan 2014 12:17:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] memblock, x86: fix big numa system booting
Message-Id: <20140124121725.fa2fb96b4002a560309bc5cd@linux-foundation.org>
In-Reply-To: <52E2BFFF.90107@ti.com>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<52E2BFFF.90107@ti.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014 14:33:19 -0500 Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> Yinghai,
> 
> On Friday 24 January 2014 02:11 PM, Yinghai Lu wrote:
> > Big numa system boot get broken while switch API from bootmem to
> > memblock_virt.
> > 
> > Revert the offending patch, and also address swiotlb regression.
> > 
> Thanks a lot for fixes and help to narrow down and fix these
> regressions. For all the patches in the series,
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

That patchset continues to boot happily on my swiotlb test box.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaLLCEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:04:33 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62465 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbaLLCEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:04:32 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412112106440.13233@nanos>
References: <20141205084147.313026156@linutronix.de>
	<tip-e9220e591375af6d02604c261999df570fba744f@git.kernel.org>
	<CAE9FiQU=Q8paxTJpqN8GFGYeq6u-E=VBtyQSVzVNYnJGEybtqw@mail.gmail.com>
	<5489AB40.2010609@linux.intel.com>
	<CAE9FiQVPGfcXOFx448ABV4zGcq70nvE4pEE4PzaWZMNj+9rHtA@mail.gmail.com>
	<alpine.DEB.2.11.1412112106440.13233@nanos>
Date: Thu, 11 Dec 2014 18:04:30 -0800
X-Google-Sender-Auth: OOgKoq40-PbfgxIhGcdc6gze0X0
Message-ID: <CAE9FiQX=4X=VpG9F67=X9cwvFhMwmCHuem7Kw7yX65dyftPyfw@mail.gmail.com>
Subject: Re: [tip:x86/apic] iommu/vt-d: Move iommu preparatory allocations to irq_remap_ops.prepare
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:30 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

> So irq_2_iommu is empty. That's a multi MSI, and that's the second
> interrupt which gets enabled.
>
> The patch below should fix it.
>

Yes, that fixes the problem.

Assume you will fold it into

commit 289472f461d922507f75dd2451770282adb3a99b
Author: Jiang Liu <jiang.liu@linux.intel.com>
Date:   Tue Nov 25 13:53:19 2014 +0800

    iommu/vt-d: Enhance Intel IR driver to suppport hierarchy irqdomain

Thanks

Yinghai

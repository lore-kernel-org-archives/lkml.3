Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3IYPQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:16:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16404 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755427Ab3IYPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:16:07 -0400
Date: Wed, 25 Sep 2013 11:16:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Jiang Liu <liuj97@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20130925111605.7437f70f@gandalf.local.home>
In-Reply-To: <CA+b37P0P0RhUytnkLSXmz28wzzsoL3-viV2oxNJqq2nP7kZBFA@mail.gmail.com>
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
	<1380105868-31985-3-git-send-email-liuj97@gmail.com>
	<20130925103535.2249f617@gandalf.local.home>
	<CA+b37P0P0RhUytnkLSXmz28wzzsoL3-viV2oxNJqq2nP7kZBFA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 20:12:17 +0530
Sandeepa Prabhu <sandeepa.prabhu@linaro.org> wrote:


> > On aarch64, are instructions always word aligned? If not, it should be
> > safe for stop machine to modify non word aligned instructions, but this
> > patch looks like it doesn't allow stop_machine() to do so.
> Steve,
> 
> Yes, aarch64 instructions must be word-aligned, else instruction fetch
> would generate Misaligned PC fault.
> 

Thanks for clarifying, as IIUC, there's ARM architectures that allow
for 2 and 4 byte instructions.

-- Steve

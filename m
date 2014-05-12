Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaELPxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:53:40 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51891 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754298AbaELPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:53:39 -0400
Date: Mon, 12 May 2014 16:52:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v6 0/4] arm64: prerequisites for audit and ftrace
Message-ID: <20140512155242.GF31633@arm.com>
References: <1398851492-16345-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398851492-16345-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 10:51:28AM +0100, AKASHI Takahiro wrote:
> AKASHI Takahiro (4):
>   arm64: make a single hook to syscall_trace() for all syscall features
>   arm64: split syscall_trace() into separate functions for enter/exit
>   arm64: Add regs_return_value() in syscall.h
>   arm64: is_compat_task is defined both in asm/compat.h and
>     linux/compat.h

Patches picked by Will and applied to the arm64 for-next/core branch
(should appear in -next at some point).

Thanks.

-- 
Catalin

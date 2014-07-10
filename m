Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaGJKI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:08:28 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20635 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752457AbaGJKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:08:27 -0400
Date: Thu, 10 Jul 2014 11:08:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>, Will Deacon <Will.Deacon@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v10 0/3] arm64: Add audit support
Message-ID: <20140710100803.GH16137@arm.com>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 08:28:28AM +0100, AKASHI Takahiro wrote:
> This patchset adds system call audit support on arm64.
> Both 32-bit (AUDIT_ARCH_ARM) and 64-bit tasks (AUDIT_ARCH_AARCH64)
> are supported. Since arm64 has the exact same set of system calls
> on LE and BE, we don't care about endianness (or more specifically
> __AUDIT_ARCH_64BIT bit in AUDIT_ARCH_*).

Applied for 3.17. Thanks.

-- 
Catalin

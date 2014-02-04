Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaBDRaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:30:55 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50731 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754807AbaBDRau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:30:50 -0500
Date: Tue, 4 Feb 2014 17:30:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v3 2/3] arm64: Add audit support
Message-ID: <20140204173021.GF664@mudshark.cambridge.arm.com>
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
 <1391410590-4884-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391410590-4884-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 06:56:29AM +0000, AKASHI Takahiro wrote:
> On AArch64, audit is supported through generic lib/audit.c and
> compat_audit.c, and so this patch adds arch specific definitions required.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/Kconfig               |    1 +
>  arch/arm64/include/asm/syscall.h |   15 +++++++++++++++
>  include/uapi/linux/audit.h       |    1 +
>  3 files changed, 17 insertions(+)

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

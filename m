Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaCNRIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:08:47 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14672 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756011AbaCNRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:08:45 -0400
Date: Fri, 14 Mar 2014 17:08:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v3 1/3] asm-generic: Add generic seccomp.h for secure
 computing mode 1
Message-ID: <20140314170814.GJ18126@arm.com>
References: <1394705823-12465-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705823-12465-2-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394705823-12465-2-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:17:01AM +0000, AKASHI Takahiro wrote:
> Those values (__NR_seccomp_*) are used solely in secure_computing()
> to identify mode 1 system calls. If compat system calls have different
> syscall numbers, asm/seccomp.h may override them.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  include/asm-generic/seccomp.h |   28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 include/asm-generic/seccomp.h

I think you need an Ack from Arnd on this patch. The other patches in
this series look ok but they depend on the ftrace patches, so we'll have
to sort those out first.

-- 
Catalin

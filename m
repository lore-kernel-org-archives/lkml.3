Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaB1P6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:58:03 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53542 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbaB1P6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:58:01 -0500
Date: Fri, 28 Feb 2014 15:57:20 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH v3 1/2] arm64: make a single hook to syscall_trace() for
 all syscall features
Message-ID: <20140228155720.GD29546@mudshark.cambridge.arm.com>
References: <1393319683-2707-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564465-3862-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564465-3862-2-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393564465-3862-2-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 05:14:24AM +0000, AKASHI Takahiro wrote:
> Currently syscall_trace() is called only for ptrace.
> With additional TIF_xx flags defined, it is now called in all the cases
> of audit, ftrace and seccomp in addition to ptrace.
> 
> Acked-by: Richard Guy Briggs <rgb@redhat.com>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

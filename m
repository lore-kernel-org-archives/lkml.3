Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161371AbaDPNyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:54:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37031 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161077AbaDPNyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:54:49 -0400
Date: Wed, 16 Apr 2014 14:48:15 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 5/7] arm64: ftrace: Add dynamic ftrace support
Message-ID: <20140416134815.GE1001@arm.com>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862353-28963-6-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394862353-28963-6-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 05:45:51AM +0000, AKASHI Takahiro wrote:
> This patch allows "dynamic ftrace" if CONFIG_DYNAMIC_FTRACE is enabled.
> Here we can turn on and off tracing dynamically per-function base.
> 
> On arm64, this is done by patching single branch instruction to _mcount()
> inserted by gcc -pg option. The branch is replaced to NOP initially at
> kernel start up, and later on, NOP to branch to ftrace_caller() when
> enabled or branch to NOP when disabled.
> Please note that ftrace_caller() is a counterpart of _mcount() in case of
> 'static' ftrace.
> 
> More details on architecture specific requirements are described in
> Documentation/trace/ftrace-design.txt.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

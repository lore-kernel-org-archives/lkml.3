Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaDPLdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:33:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64825 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbaDPLdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:33:10 -0400
Date: Wed, 16 Apr 2014 12:30:03 +0100
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
Subject: Re: [PATCH_v8 2/2] arm64: audit: Add audit hook in
 syscall_trace_enter/exit()
Message-ID: <20140416113002.GG29754@arm.com>
References: <1394705767-12423-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862548-29060-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862548-29060-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394862548-29060-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 05:49:08AM +0000, AKASHI Takahiro wrote:
> This patch adds auditing functions on entry to or exit from
> every system call invocation.
> 
> Acked-by: Richard Guy Briggs <rgb@redhat.com>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

I think I already acked this patch.

Will

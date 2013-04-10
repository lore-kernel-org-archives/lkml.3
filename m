Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981Ab3DJLlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:41:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65508 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935745Ab3DJLlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:41:52 -0400
Date: Wed, 10 Apr 2013 12:41:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: Fix task tracing
Message-ID: <20130410114126.GB26992@mudshark.cambridge.arm.com>
References: <20130408153132.GQ17476@mudshark.cambridge.arm.com>
 <1365510814-21343-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365510814-21343-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 01:33:34PM +0100, Christopher Covington wrote:
> For accurate accounting pass contextidr_thread_switch the prev
> task pointer, since cpu_switch_to has at that point changed the
> the stack pointer.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>

Thanks Christopher -- I assume that using prev did resolve your issues?

Will

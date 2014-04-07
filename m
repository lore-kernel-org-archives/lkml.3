Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaDGQg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:36:28 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59038 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753057AbaDGQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:36:22 -0400
Date: Mon, 7 Apr 2014 17:35:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Add missing Kconfig for CONFIG_STRICT_DEVMEM
Message-ID: <20140407163545.GB8479@arm.com>
References: <1396657850-14252-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396657850-14252-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 01:30:50AM +0100, Laura Abbott wrote:
> The Kconfig for CONFIG_STRICT_DEVMEM is missing despite being
> used in mmap.c. Add it.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Thanks. Applied.

-- 
Catalin

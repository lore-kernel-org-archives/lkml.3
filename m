Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3CSQKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:10:34 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56626 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754705Ab3CSQKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:10:33 -0400
Date: Tue, 19 Mar 2013 16:10:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS
Message-ID: <20130319161006.GA9321@arm.com>
References: <1363707697.1390.13.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363707697.1390.13.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 03:41:37PM +0000, Paul Bolle wrote:
> The Kconfig entry for DEBUG_ERRORS is a verbatim copy of the former arm
> entry for that symbol. It got removed in v2.6.39 because it wasn't
> actually used anywhere. There are still no users of DEBUG_ERRORS so
> remove this entry too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, applied.

-- 
Catalin

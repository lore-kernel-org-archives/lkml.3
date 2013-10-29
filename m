Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3J2Qmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:42:43 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50418 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751469Ab3J2Qmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:42:42 -0400
Date: Tue, 29 Oct 2013 16:41:42 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: allow ioremap_cache() to use existing RAM
 mappings
Message-ID: <20131029164142.GF3472@arm.com>
References: <1382362594-24947-1-git-send-email-msalter@redhat.com>
 <1382519898.10408.1.camel@mbp>
 <1382535972.1768.68.camel@deneb.redhat.com>
 <20131023143717.GA19317@mbp>
 <1382626457.1768.80.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382626457.1768.80.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 03:54:17PM +0100, Mark Salter wrote:
> Some drivers (ACPI notably) use ioremap_cache() to map an area which could
> either be outside of kernel RAM or in an already mapped reserved area of
> RAM. To avoid aliases with different caching attributes, ioremap() does
> not allow RAM to be remapped. But for ioremap_cache(), the existing kernel
> mapping may be used.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Looks good. Thanks.

-- 
Catalin

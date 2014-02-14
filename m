Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBNKRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:17:34 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27259 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751065AbaBNKRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:17:31 -0500
Date: Fri, 14 Feb 2014 10:17:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: mm: report both sections from PMD
Message-ID: <20140214101724.GC10590@arm.com>
References: <20140213195230.GA15275@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213195230.GA15275@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 07:52:30PM +0000, Kees Cook wrote:
> On 2-level page table systems, the PMD has 2 section entries. Report
> these, otherwise ARM_PTDUMP will miss reporting permission changes on
> odd section boundaries.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

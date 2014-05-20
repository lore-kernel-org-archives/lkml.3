Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaETJHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:07:38 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:58418 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752788AbaETJHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:07:36 -0400
Date: Tue, 20 May 2014 10:07:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] mm/kmemleak-test.c: use pr_fmt for logging
Message-ID: <20140520090719.GE4822@arm.com>
References: <20140519212513.d1a073065c000cde2394f8cd@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519212513.d1a073065c000cde2394f8cd@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 08:25:13PM +0100, Fabian Frederick wrote:
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  mm/kmemleak-test.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

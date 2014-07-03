Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbaGCSOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:14:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60344 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758970AbaGCSOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:14:49 -0400
Date: Thu, 3 Jul 2014 19:14:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/5] lib/genalloc.c: Add genpool range check function
Message-ID: <20140703181425.GK17372@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org>
 <1404324218-4743-3-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404324218-4743-3-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 07:03:35PM +0100, Laura Abbott wrote:
> 
> After allocating an address from a particular genpool,
> there is no good way to verify if that address actually
> belongs to a genpool. Introduce addr_in_gen_pool which
> will return if an address plus size falls completely
> within the genpool range.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---

Acked-by: Will Deacon <will.deacon@arm.com>

Will

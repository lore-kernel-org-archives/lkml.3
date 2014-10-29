Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaJ2J0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:26:38 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49570 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJ2J0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:26:09 -0400
Date: Wed, 29 Oct 2014 09:25:58 +0000
From: Steve Capper <steve.capper@linaro.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        benh@kernel.crashing.org, mpe@ellerman.id.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH V4 1/2] mm: Update generic gup implementation to handle
 hugepage directory
Message-ID: <20141029092557.GA3440@linaro.org>
References: <1414570785-18966-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414570785-18966-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 01:49:44PM +0530, Aneesh Kumar K.V wrote:
> Update generic gup implementation with powerpc specific details.
> On powerpc at pmd level we can have hugepte, normal pmd pointer
> or a pointer to the hugepage directory.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Acked-by: Steve Capper <steve.capper@linaro.org>

Thanks Aneesh,
--
Steve

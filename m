Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaJAOAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:00:09 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40125 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaJAOAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:00:07 -0400
Date: Wed, 1 Oct 2014 14:59:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 18/24] ARM64: Add vdso for ILP32 and use it for the
 signal return
Message-ID: <20141001135957.GM12702@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-19-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-19-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:19:12PM +0100, Andrew Pinski wrote:
> This patch adds the VDSO for ILP32. We need to use a different
> VDSO than LP64 since ILP32 uses ELF32 while LP64 uses ELF64.
> 
> After this patch, signal handling works mostly.  In that signals
> go through their action and then returned correctly.

As you say "mostly", is there anything that does not work?

-- 
Catalin

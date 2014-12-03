Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaLCKcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:32:22 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43894 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaLCKcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:32:21 -0500
Date: Wed, 3 Dec 2014 10:32:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mason <mpeg.blue@free.fr>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Creating 16 MB super-sections for MMIO
Message-ID: <20141203103211.GB7373@e104818-lin.cambridge.arm.com>
References: <547D97A5.4090302@free.fr>
 <547EDD61.5080907@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547EDD61.5080907@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 09:52:33AM +0000, Mason wrote:
> [Top-posting to address topicality]
> 
> Is LKML more appropriate a list to discuss MMU setup?
> (I've been studying arch-specific code in arch/arm/mm)

The list is fine. The reasons behind this proposal aren't clear. Are you
trying to optimise mmio register accesses by avoiding TLB misses?

-- 
Catalin

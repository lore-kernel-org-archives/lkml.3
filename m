Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaJBQ0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:26:32 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40687 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaJBQ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:26:31 -0400
Date: Thu, 2 Oct 2014 17:26:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Min-Hua Chen <orca.chen@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND]arm64: Use phys_addr_t type for physical address
Message-ID: <20141002162615.GL32147@e104818-lin.cambridge.arm.com>
References: <CAHkaATT2=WYuUA9yyWJbjChT43Fp-WZqgpgS-Twyd+AKHLHwxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkaATT2=WYuUA9yyWJbjChT43Fp-WZqgpgS-Twyd+AKHLHwxQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 03:56:59PM +0100, Min-Hua Chen wrote:
> Change the type of physical address from unsigned long to phys_addr_t,
> make valid_phys_addr_range more readable.
> 
> Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>

Applied. Thanks.

-- 
Catalin

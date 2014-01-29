Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaA2IlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:41:17 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:24092 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA2IlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:41:16 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
Date: Wed, 29 Jan 2014 09:41:12 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Alistair Popple <alistair@popple.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git next branch
Message-ID: <20140129084112.GA1331@aepfle.de>
References: <1390883744.3872.76.camel@pasglop>
 <20140128150309.GA7428@aepfle.de>
 <1390940395.8524.25.camel@pasglop>
 <4555187.D5eRSF5r8x@mexican>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4555187.D5eRSF5r8x@mexican>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, Alistair Popple wrote:

> Looks like I missed the dart iommu code when changing the iommu table
> initialisation. The patch below should fix it, would you mind testing it Ben?

> +++ b/arch/powerpc/sysdev/dart_iommu.c

> + iommu_table_dart.it_page_shift = IOMMU_PAGE_SHIFT_4K;


Yes, that fixes it for me. Thanks!

Olaf

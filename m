Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaHUXrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:47:16 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:39251 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaHUXrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140821142844.741564f85014633db067408f@linux-foundation.org>
References: <1408482646-22541-1-git-send-email-bobby.prani@gmail.com> <20140821142844.741564f85014633db067408f@linux-foundation.org>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 21 Aug 2014 19:46:42 -0400
Message-ID: <CAJhHMCBtrLrNr=ok=dJivGx5_HwwxvX-NF1fHBgrObzwQhvMag@mail.gmail.com>
Subject: Re: [PATCH] edac: Fix build error caused by wrong member access
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "open list:EDAC-CORE" <linux-edac@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 5:28 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> This driver seems pretty unhealthy and I suspect it has been
> broken for quite a while.
>
> drivers/edac/ppc4xx_edac.c: In function 'mfsdram':
> drivers/edac/ppc4xx_edac.c:249: error: implicit declaration of function '__mfdcri'
> drivers/edac/ppc4xx_edac.c: In function 'mtsdram':
> drivers/edac/ppc4xx_edac.c:266: error: implicit declaration of function '__mtdcri'
> drivers/edac/ppc4xx_edac.c:269: warning: 'return' with a value, in function returning void
> drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_init_csrows':
> drivers/edac/ppc4xx_edac.c:924: warning: initialization from incompatible pointer type
> drivers/edac/ppc4xx_edac.c:977: error: request for member 'dimm' in something not a structure or union
> drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_map_dcrs':
> drivers/edac/ppc4xx_edac.c:1209: warning: passing argument 1 of 'dcr_map_mmio' discards qualifiers from pointer target type
>
>

Yes, not sure if anyone is actually using it.

Anways, I will send in a patch to fix the errors which you point out here.

-- 
Pranith

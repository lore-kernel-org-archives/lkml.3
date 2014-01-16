Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaAPNPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:15:36 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:44095 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaAPNP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:15:29 -0500
Date: Thu, 16 Jan 2014 14:15:21 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree
 (akpm-current related)
Message-ID: <20140116141521.015fea81@lilie>
In-Reply-To: <20140116173638.5a1f01f8efb8cb7d48e021b0@canb.auug.org.au>
References: <20140116173638.5a1f01f8efb8cb7d48e021b0@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011613-0342-0000-0000-00000777E1E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

thanks for reminding me...

Am Thu, 16 Jan 2014 17:36:38 +1100
schrieb Stephen Rothwell <sfr@canb.auug.org.au>:
> mm/nobootmem.c: In function 'free_low_memory_core_early':
> mm/nobootmem.c:119:26: warning: unused variable
> 'size' [-Wunused-variable]
> Introduced by commit dd3ff251123c ("mm/nobootmem: free_all_bootmem
> again") from the akpm-current tree.

Will send a new version of the patch today.

Philipp


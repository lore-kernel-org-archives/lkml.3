Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaESHSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:18:25 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40486 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaESHSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:18:23 -0400
Date: Mon, 19 May 2014 09:18:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: gather_hugetbl_stats() doesn't use huge_pte...() variants
Message-ID: <20140519091817.559e550b@mschwide>
In-Reply-To: <537645D1.7020403@intel.com>
References: <537645D1.7020403@intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051907-3548-0000-0000-0000091CA278
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, 16 May 2014 10:07:29 -0700
Dave Hansen <dave.hansen@intel.com> wrote:

> Is the numa maps gather_hugetbl_stats() buggy on s390?  It uses the
> normal pte_ variants.

That would be broken if we ever enable CONFIG_NUMA. Right now s390 does
not support NUMA, the gather_hugetbl_stats code is dead code for us.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


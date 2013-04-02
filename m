Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab3DBKCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:02:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37277 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760277Ab3DBKCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:02:21 -0400
Message-ID: <515AAC9D.4010001@ti.com>
Date: Tue, 2 Apr 2013 15:32:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2] ARM: davinci: use is IS_ENABLED macro
References: <1364800424-4239-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1364800424-4239-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/2013 12:43 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patches replaces #if defined() by IS_ENABLED macro, which provides
> better readability.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Randy Dunlap <rdunlap@infradead.org>

I dropped earlier version of this patch and queued this one instead.

Thanks,
Sekhar

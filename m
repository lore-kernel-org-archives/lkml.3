Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaAXTeC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:34:02 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58767 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaAXTeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:34:01 -0500
Message-ID: <52E2BFFF.90107@ti.com>
Date: Fri, 24 Jan 2014 14:33:19 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] memblock, x86: fix big numa system booting
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,

On Friday 24 January 2014 02:11 PM, Yinghai Lu wrote:
> Big numa system boot get broken while switch API from bootmem to
> memblock_virt.
> 
> Revert the offending patch, and also address swiotlb regression.
> 
Thanks a lot for fixes and help to narrow down and fix these
regressions. For all the patches in the series,

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


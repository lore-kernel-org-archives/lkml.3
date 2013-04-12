Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3DLBGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:06:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3DLBGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:06:54 -0400
MIME-Version: 1.0
Message-ID: <4b78b961-eb82-4f32-aa09-345c1c1d39c5@default>
Date: Thu, 11 Apr 2013 18:05:44 -0700 (PDT)
From: Konrad Wilk <konrad.wilk@oracle.com>
To: <yinghai@kernel.org>
Cc: <trenn@suse.de>, <tangchen@cn.fujitsu.com>, <tglx@linutronix.de>,
        <penberg@kernel.org>, <akpm@linux-foundation.org>, <mingo@elte.hu>,
        <jacob.shin@amd.com>, <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v4 21/22] x86, mm: Make init_mem_mapping be able to be
 called several times
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- yinghai@kernel.org wrote:

> Prepare to put page table on local nodes.
> 
> Move calling of init_mem_mapping to early_initmem_init.
> 
> Rework alloc_low_pages to alloc page table in following order:
> 	BRK, local node, low range
> 
> Still only load_cr3 one time, otherwise we would break xen 64bit
> again.

I have asked you in the previous iteration of the patch to fix that comment.

Please remove it - as it is misleading. The issue with load_cr3 more than
once has been fixed under the Xen platform.


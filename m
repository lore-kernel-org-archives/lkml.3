Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab3HSSy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:54:28 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38146 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3HSSy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:54:26 -0400
Message-ID: <1376938384.10300.458.camel@misato.fc.hp.com>
Subject: Re: [PATCH 3/6] acpi cleanup: Use pr_info() instead of printk() in
 arch/x86/mm/srat.c
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Mon, 19 Aug 2013 12:53:04 -0600
In-Reply-To: <1376636809-10159-4-git-send-email-tangchen@cn.fujitsu.com>
References: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1376636809-10159-4-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 15:06 +0800, Tang Chen wrote:
> Use pr_info() instead of printk() in arch/x86/mm/srat.c.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>

Please fold patch 4/6 into this patch 3/6 since they both are printk()
cleanup on the same file.  I do not see why they need to be separated.
With that change,

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934539Ab3CZOcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:32:47 -0400
Received: from 8bytes.org ([85.214.48.195]:45208 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759801Ab3CZOcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:32:46 -0400
Date: Tue, 26 Mar 2013 15:32:40 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: konrad.wilk@oracle.com, sebastian@breakpoint.cc, suresh.b.siddha@intel.com,
        yinghai@kernel.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] x86, io_apic: remove duplicated include from
 irq_remapping.c
Message-ID: <20130326143239.GA2727@8bytes.org>
References: <CAPgLHd9QgppJ1mR3F6jkTJYOZLD5rbJwcy+KEEZSjtVPtHHdRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9QgppJ1mR3F6jkTJYOZLD5rbJwcy+KEEZSjtVPtHHdRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar 26 15:32:43 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5151b18b23671277890292
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:21:28PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied to iommu/fixes, thanks.



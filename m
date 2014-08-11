Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaHKNNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:13:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHKNNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:13:24 -0400
Date: Mon, 11 Aug 2014 06:13:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/18] arcmsr: precise checking adapter ID
Message-ID: <20140811131320.GA23810@infradead.org>
References: <1407142512.4756.54.camel@Centos6.3-64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407142512.4756.54.camel@Centos6.3-64>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 04:55:12PM +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
> 
> This patch rewrites the arcmsr_define_adapter_type function to precisely check Areca adapter's ID.
> This can prevent an unknown adapter being used as a default adapter type by driver.
> 
> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> ---
> 
> Thanks for Christoph advice.

This still doesn't use the private_data field in the pci device table.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaE1LMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:12:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56677 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaE1LMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:12:46 -0400
Date: Wed, 28 May 2014 04:12:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: remove stub qlt_check_srr_debug()
Message-ID: <20140528111243.GA32216@infradead.org>
References: <1400940192.22523.59.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400940192.22523.59.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 04:03:12PM +0200, Paul Bolle wrote:
> qlt_check_srr_debug() was added in v3.5. It is a stub function unless
> CONFIG_QLA_TGT_DEBUG_SRR is defined. But CONFIG_QLA_TGT_DEBUG_SRR will
> never be defined, because the Kconfig symbol QLA_TGT_DEBUG_SRR was never
> added to the tree.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaI3PhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:37:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaI3PhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:37:03 -0400
Date: Tue, 30 Sep 2014 08:36:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, robert.w.love@intel.com,
        JBottomley@parallels.com, fcoe-devel@open-fcoe.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] libfs: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140930153654.GA32496@infradead.org>
References: <20140818145622.GA14281@ada>
 <1411682471.2856.3.camel@vfc0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411682471.2856.3.camel@vfc0>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

applied to drivers-for-3.18

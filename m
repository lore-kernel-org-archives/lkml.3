Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaJWRMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:12:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaJWRM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:12:29 -0400
Date: Thu, 23 Oct 2014 10:12:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: JBottomley@parallels.com, Mark Rustad <mark.d.rustad@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Resolve some missing-field-initializers warnings
Message-ID: <20141023171223.GC16015@infradead.org>
References: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

applied to the core-for-3.19 branch.

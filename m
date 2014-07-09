Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaGIIo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:44:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaGIIoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:44:54 -0400
Date: Wed, 9 Jul 2014 01:44:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Message-ID: <20140709084453.GG6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404866812-26950-7-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:51PM -0700, K. Y. Srinivasan wrote:
> Correctly set SRB flags for all valid I/O directions. Some IHV drivers on the
> Windows host require this.

What are IHV drivers?


Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

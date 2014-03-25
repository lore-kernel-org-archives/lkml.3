Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaCYPbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:31:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaCYPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:31:04 -0400
Date: Tue, 25 Mar 2014 08:31:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/39] virtio_scsi: use cmd_size
Message-ID: <20140325153104.GA25748@infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
 <20140317133133.814453025@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317133133.814453025@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo,

do you have a virtio_scsi tree to picks this up in?  We now have all
the infrastructure for it in James' tree.

Btw, it would also be interesting to see if we could get rid of
virtscsi_cmd_cache/pool by reusing fields in EH, but I didn't feel
familar enough with the driver to look into that.


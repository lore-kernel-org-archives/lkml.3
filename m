Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaJQN0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:26:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaJQN0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:26:11 -0400
Date: Fri, 17 Oct 2014 06:26:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: JBottomley@parallels.com, Mark Rustad <mark.d.rustad@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Resolve some missing-field-initializers warnings
Message-ID: <20141017132611.GM16538@infradead.org>
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

On Tue, Oct 14, 2014 at 06:38:53AM -0700, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Resolve some missing-field-initializers warnings by using
> designated initialization.

What tool is warning about these?  This construct is perfectly valid C.

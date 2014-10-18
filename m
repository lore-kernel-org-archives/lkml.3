Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaJRPPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:15:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaJRPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:15:18 -0400
Date: Sat, 18 Oct 2014 08:15:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: Resolve some missing-field-initializers warnings
Message-ID: <20141018151517.GE30355@infradead.org>
References: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141017132611.GM16538@infradead.org>
 <C69957AC-DB35-467C-85B1-091B740C74C9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C69957AC-DB35-467C-85B1-091B740C74C9@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:44:36PM +0000, Rustad, Mark D wrote:
> The warning appears in W=2 builds. I had another way to silence it by using diagnostic control macros, but those macros were not accepted. Using a single designated initialization also silences it.


Oh well.  I think the earlier version was slightly cleaner, but if it
helps people to catch real bugs better I'm happy to apply it.

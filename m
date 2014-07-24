Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbaGXPe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:34:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114AbaGXPe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:34:26 -0400
Date: Thu, 24 Jul 2014 08:34:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Message-ID: <20140724153419.GA10372@infradead.org>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1iommkgkv.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 09:54:24AM -0400, Martin K. Petersen wrote:
> I'm very much against short-circuiting the LBP logic in a passthrough
> driver because then we might end up in the exact situation we were
> trying to avoid with this patch series. Namely sending down commands
> unsupported by the target device.
> 
> This kind of thing really needs to be a sysadmin decision and can be
> handled with a udev rule.

I agree - I'd like to pull in KY's simple fix as soon as I get a second
review for it.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbaGRRAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:00:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbaGRRAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:00:33 -0400
Date: Fri, 18 Jul 2014 10:00:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Message-ID: <20140718170030.GA31769@infradead.org>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401899623-24194-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:33:43AM -0700, K. Y. Srinivasan wrote:
> Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to derive the
> FLUSH_TIMEOUT from the basic I/O timeout. However, this patch did not use the
> basic I/O timeout of the device. Fix this bug.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(it will need some changes to apply to my tree, but I'm happy to do that
if I can get another review).

James, does this look fine to you?


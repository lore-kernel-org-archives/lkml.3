Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaGIIoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:44:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaGIIoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:44:15 -0400
Date: Wed, 9 Jul 2014 01:44:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Message-ID: <20140709084415.GF6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404866812-26950-6-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:50PM -0700, K. Y. Srinivasan wrote:
> Implement a simple abort handler. The host does not support "Abort"; just
> ensure that all inflight I/Os have been accounted for.

The abort handler should abort a single command, not wait for all of
them.  What issue do you see that this tries to address?


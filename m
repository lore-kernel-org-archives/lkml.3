Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaGIIl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:41:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaGIIly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:41:54 -0400
Date: Wed, 9 Jul 2014 01:41:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
 protocol version
Message-ID: <20140709084154.GC6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-3-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404866812-26950-3-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if ((vmbus_proto_version == VERSION_WS2008) ||
> +	     (vmbus_proto_version == VERSION_WIN7)) {

This has superflous braces and doesn't use proper Linux indentation.

But I think simply using a switch here might be cleaner anyway.


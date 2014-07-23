Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbaGWLvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:51:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaGWLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:51:36 -0400
Date: Wed, 23 Jul 2014 04:51:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Message-ID: <20140723115128.GB16881@infradead.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723100448.GA2540@sucs.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:04:48AM +0100, Sitsofe Wheeler wrote:
> OK I've just seen this as I was about to post a similar patch to get
> discard going on Hyper-V. Will your patches handle Hyper-V pass through devices
> that support discard? The SSD I have here reports the following in the Linux
> VM:

I didn't know hyperv also supports pass through, but it should work fine.
The only thing I'm worried about is real SCSI-2 devices or crappy USB
devices that don't support EVPD pages and might cause problems.  But
let's ignore that problem for now..


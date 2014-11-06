Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaKFHCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:02:33 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFHC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:02:29 -0500
Date: Wed, 5 Nov 2014 23:02:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>,
        Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>,
        Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] libata: use __scsi_format_command()
Message-ID: <20141106070225.GB19721@infradead.org>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-5-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415088409-46590-5-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:06:43AM +0100, Hannes Reinecke wrote:
> libata already uses an internal buffer, so we should be using
> __scsi_format_command() here.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaHGGfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:35:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaHGGft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:35:49 -0400
Date: Wed, 6 Aug 2014 23:35:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: jgross@suse.com
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5] Save command pool address of Scsi_Host
Message-ID: <20140807063547.GA8151@infradead.org>
References: <1407151802-27198-1-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407151802-27198-1-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I get another review for this one so I can queue it up for 3.17?
(or v4 if you have a strong preference for it..)


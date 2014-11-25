Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaKYOoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:44:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaKYOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:44:15 -0500
Date: Tue, 25 Nov 2014 06:44:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 0/3] wd719x: Introduce Western Digital
 WD7193/7197/7296 PCI SCSI card driver
Message-ID: <20141125144413.GB22764@infradead.org>
References: <1416867882-29344-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416867882-29344-1-git-send-email-linux@rainbow-software.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied the series to drivers-for-3.19.

I had to add an include of <linux/interrupt.h> to make it compile on my
setup, though.


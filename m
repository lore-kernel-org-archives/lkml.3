Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaLOIWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:22:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaLOIWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:22:41 -0500
Date: Mon, 15 Dec 2014 00:22:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [Update][PATCH] SCSI / PM: Replace CONFIG_PM_RUNTIME with
 CONFIG_PM
Message-ID: <20141215082239.GB24067@infradead.org>
References: <3237237.IIIiULdqDt@vostro.rjw.lan>
 <3039454.iyzHXUp3Uj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3039454.iyzHXUp3Uj@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 10:47:47PM +0100, Rafael J. Wysocki wrote:
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Feel free to add it to the linux-pm tree.

Acked-by: Christoph Hellwig <hch@lst.de>

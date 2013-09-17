Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3IQUaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:30:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3IQUaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:30:13 -0400
Date: Tue, 17 Sep 2013 13:30:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>,
        "open list:USB MASS STORAGE..." 
	<usb-storage@lists.one-eyed-alien.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] uas: make work list per-device
Message-ID: <20130917203012.GA1752@infradead.org>
References: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
 <1379071635-30701-4-git-send-email-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379071635-30701-4-git-send-email-kraxel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 01:27:12PM +0200, Gerd Hoffmann wrote:
> Simplifies locking, we'll protect the list with the device spin lock.
> Also plugs races which can happen when two devices operate on the
> global list.
> 
> While being at it rename the list head from "list" to "work", preparing
> for the addition of a second list.

Why do you even the list?  What would a ordered per-device workqueue not
provide?


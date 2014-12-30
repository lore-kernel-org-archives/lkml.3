Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaL3JcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 04:32:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaL3JcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 04:32:13 -0500
Date: Tue, 30 Dec 2014 01:32:10 -0800
From: "hch@infradead.org" <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
Message-ID: <20141230093210.GA6294@infradead.org>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <BY2PR0301MB0711853294B88172F1AAF24FA0510@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY2PR0301MB0711853294B88172F1AAF24FA0510@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 09:07:59PM +0000, KY Srinivasan wrote:
> Should I be resending these patches.

I don't need a resend, I need a review for the patches.  Note that for
driver patches I'm also fine with a review from a co worker, as long as
it's a real review not just a rubber stamp.

Talking about process:  for the next submission please only use
"storvsc:  " as the subject prefix, I had to remove "Drivers: scsi: "
which doesn'd add useful information every time so far.

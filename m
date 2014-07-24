Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbaGXQYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:24:37 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36550 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbaGXQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:24:36 -0400
Date: Thu, 24 Jul 2014 17:24:27 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Message-ID: <20140724162427.GA10962@sucs.org>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net>
 <20140724153419.GA10372@infradead.org>
 <20140724153513.GA10752@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724153513.GA10752@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 08:35:13AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 24, 2014 at 08:34:19AM -0700, Christoph Hellwig wrote:
> > I agree - I'd like to pull in KY's simple fix as soon as I get a second
> > review for it.
> 
> Ok, looks like I just got that from Hannes.  Let's see if there's more
> to be done for the pass through case, but I'd rather wait for the next
> window for that.

There's nothing Linux can do for today's Hyper-V passthrough wrt to
automatically turning on discard on my SATA SSD.

Martin explained that vendors often disable UNMAP/WRITE SAME to DSM TRIM
translation on purpose and/or have explicit device whitelists/blacklists
for those devices they want to support. It could be that Microsoft are
doing something similar (although it might be interesting to know how a
Windows 2012 guest on Hyper-V handles things).

-- 
Sitsofe | http://sucs.org/~sits/

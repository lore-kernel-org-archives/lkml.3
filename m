Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbaGPR24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:28:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32921 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760453AbaGPR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:28:53 -0400
Date: Wed, 16 Jul 2014 10:28:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Hannes Reinecke <hare@suse.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to
 reflect the values on the host
Message-ID: <20140716172850.GA10159@infradead.org>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
 <53C37575.5030808@suse.de>
 <20140714083047.GB22715@infradead.org>
 <53C39B91.4010000@suse.de>
 <e6f205c16ba2414ab5645977ac038e6c@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6f205c16ba2414ab5645977ac038e6c@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 05:26:48PM +0000, KY Srinivasan wrote:
> Christoph,
> 
> Is this patch-set ready to be checked in. Let me know if you want me to make any
> further corrections.

Hi Ky,

I've applied it locally, but I'm still waiting on reviews for two
important core fixes before pushing out the updated tree.

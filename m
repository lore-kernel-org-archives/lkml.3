Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaIRLuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:50:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaIRLuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:50:20 -0400
Date: Thu, 18 Sep 2014 13:50:17 +0200
From: Olaf Hering <ohering@suse.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Message-ID: <20140918115017.GA20884@suse.com>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
 <155acb7b8a3d4532aaa280e44f62447f@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140917073324.GB23716@suse.com>
 <20140917232309.GA4554@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140917232309.GA4554@infradead.org>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, Christoph Hellwig wrote:

> Also the two patches at
> http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/56242/

Wasnt the outcome that this was a bad idea? Or at least doing it
globally is bad. In any case, its not something I can help with.


Olaf

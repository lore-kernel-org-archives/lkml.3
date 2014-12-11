Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbaLKKx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:53:56 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33130 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaLKKxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:53:54 -0500
Date: Thu, 11 Dec 2014 10:53:45 +0000
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Long Li <longli@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Message-ID: <20141211101945.GA25624@sucs.org>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
 <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
 <BY2PR0301MB0711CF1C9FBD8EFED89B3911A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY2PR0301MB0711CF1C9FBD8EFED89B3911A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:30:30PM +0000, KY Srinivasan wrote:
> 
> > >
> > > +	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
> > >
> > > Is that version field meaningful or is it safe for us to inquire about
> > > VPD pages without problems on older versions?
> > 
> > This version is used in all current Hyper-V hosts: Windows 2008 R2, 2012 and
> > 2012 R2. However it may change in future Windows releases.
> 
> The next version of the host will be claiming conformance to SPC-3

Will the version number ("1.0") of Virtual Disks also be changed? Part
of me hopes it will as it will mean certain quirks for virtual disks
will be easier to apply and won't need host version (are you 2008, 2012,
2016) version logic...

-- 
Sitsofe | http://sucs.org/~sits/

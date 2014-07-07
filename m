Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaGGSec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaGGSea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:34:30 -0400
Date: Mon, 7 Jul 2014 20:03:25 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "DL-MPTFusionLinux@lsi.com" <DL-MPTFusionLinux@lsi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-linux-scu@intel.com" <intel-linux-scu@intel.com>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "support@lsi.com" <support@lsi.com>,
        "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>
Subject: Re: [PATCH v2 RESEND 00/23] scsi: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Message-ID: <20140707180324.GA23039@dhcp-26-207.brq.redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
 <20140424170903.GA29593@google.com>
 <1398361868.6766.0.camel@dabdike>
 <CAErSpo6nf0adD40w+99b2Nn4yO8bL=qGNV1akAMR7XkTk23ZHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6nf0adD40w+99b2Nn4yO8bL=qGNV1akAMR7XkTk23ZHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:07:12PM -0600, Bjorn Helgaas wrote:
> >> These depend on f7fc32c, which appeared in v3.15-rc1.  I had intended
> >> to merge these scsi updates at the same time, but I failed.  Would you
> >> like to take them now that f7fc32c is upstream?
> >
> > OK, will add them.  I'm planning to base the scsi-misc tree on -rc3 once
> > we have our current crop of fixes upstream.
> 
> Great, thanks!

James, Bjorn,

All patches except 'be2iscsi' (patch 1) and 'hpsa' (patches 9,10) still
apply. Would you take those apply or have me resend all of them or just
'be2iscsi' and 'hpsa'?

Thanks!

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

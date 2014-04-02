Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbaDBRAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:00:55 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59614 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaDBRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140402114932.GB10007@dhcp-26-207.brq.redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com> <20140313040440.GB26657@google.com>
 <20140402114932.GB10007@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 2 Apr 2014 11:00:31 -0600
Message-ID: <CAErSpo4Bz1PCj0kU7WwtJj7zhmomGzRTzcB5N2HKS8tNsNk69Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/23] scsi: Use pci_enable_msix_range() instead of pci_enable_msix()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iss_storagedev@hp.com, intel-linux-scu@intel.com,
        Support <support@lsi.com>,
        DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
        qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com,
        pv-drivers@vmware.com,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 5:49 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Wed, Mar 12, 2014 at 10:04:40PM -0600, Bjorn Helgaas wrote:
>> Hi James,
>>
>> I think Alexander sent these to linux-scsi hoping that you would handle
>> them, but I know it's a hassle because they depend on f7fc32c, which went
>> in after the merge window.
>>
>> I'd be glad to review these and apply them through my tree, unless you want
>> to do it.  I'd like to get these merged in the v3.15 merge window so
>> Alexander can move on to something else.  I haven't checked for merge
>> conflicts with scsi.git yet, but I assume they'd be pretty trivial if there
>> are any.
>
> Hi Bjorn,
>
> It has shifted to v3.16, right?

Yep, sorry, I meant to get to these, but was too busy, so they'll
probably go in v3.16.

Bjorn

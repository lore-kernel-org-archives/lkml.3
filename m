Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3GDCWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 22:22:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:53594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3GDCWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 22:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="364521337"
Date: Thu, 4 Jul 2013 10:22:15 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haicheng Li <haicheng.lee@gmail.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/3] doc: add the description for pci=hide kernel
 parameter.
Message-ID: <20130704022215.GA3244@hli22-desktop>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
 <1372864578-6925-2-git-send-email-haicheng.li@linux.intel.com>
 <CAErSpo72XRbZYcepdHyhmY4oAqU1qLtCCXsEsyiCTvNCwvNktg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo72XRbZYcepdHyhmY4oAqU1qLtCCXsEsyiCTvNCwvNktg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 10:00:41AM -0600, Bjorn Helgaas wrote:
> On Wed, Jul 3, 2013 at 9:16 AM, Haicheng Li <haicheng.li@linux.intel.com> wrote:
> > Cc: Rob Landley <rob@landley.net>
> > Cc: linux-doc@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> > ---
> >  Documentation/kernel-parameters.txt |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 2fe6e76..4da0834 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2359,6 +2359,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >                 pcie_scan_all   Scan all possible PCIe devices.  Otherwise we
> >                                 only look for one device below a PCIe downstream
> >                                 port.
> > +               hide=           Format: [<domain>:]<bus>:<slot>.<func>[; ...]
> > +                               Specifies devices to hide from pci subsystem.
> >
> >         pcie_aspm=      [PCIE] Forcibly enable or disable PCIe Active State Power
> >                         Management.
> 
> The documentation update should be in the same patch as the
> functionality it adds.

Okay, got it. thanks.

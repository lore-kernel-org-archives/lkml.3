Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3FFUKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:10:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59115 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3FFUKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:10:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joe Perches <joe@perches.com>, Betty Dall <betty.dall@hp.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        Huang Ying <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 4/6] PCI/ACPI: Move AER severity defines to aer.h
Date: Thu, 06 Jun 2013 22:19:24 +0200
Message-ID: <6437308.8LYcFHpCne@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo56-AtgJzkJqK+8ggdPiPPvX_AVWhsirZRdNLhdAn8qVw@mail.gmail.com>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com> <1370542987.2209.18.camel@joe-AO722> <CAErSpo56-AtgJzkJqK+8ggdPiPPvX_AVWhsirZRdNLhdAn8qVw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 06, 2013 01:28:28 PM Bjorn Helgaas wrote:
> On Thu, Jun 6, 2013 at 12:23 PM, Joe Perches <joe@perches.com> wrote:
> > On Thu, 2013-06-06 at 12:10 -0600, Betty Dall wrote:
> >> The function aer_recover_queue() is a public interface and the
> >> severity argument uses #defines that are in the private header
> >> pci/pcie/aer/aerdrv.h.
> >>
> >> This patch moves the #defines from pci/pcie/aer/aerdrv.h to
> >> include/linux/aer.h.
> > []
> >> diff --git a/include/linux/aer.h b/include/linux/aer.h
> > []
> >> -extern void cper_print_aer(const char *prefix, struct pci_dev *dev,
> >> +void cper_print_aer(const char *prefix, struct pci_dev *dev,
> >>                          int cper_severity, struct aer_capability_regs *aer);
> >
> > Can you please also realign the arguments on subsequent
> > lines to the open parenthesis of the first line and reflow
> > then to 80 cols when appropriate?
> 
> I can do this when I apply them, so don't bother reposting unless you
> have more substantive changes to make.

For the record, I have no objections against this patchset.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

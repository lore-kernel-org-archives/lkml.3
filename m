Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3FFT27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:28:59 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:61450 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3FFT2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <1370542987.2209.18.camel@joe-AO722>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
 <1370542251-27387-5-git-send-email-betty.dall@hp.com> <1370542987.2209.18.camel@joe-AO722>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Jun 2013 13:28:28 -0600
Message-ID: <CAErSpo56-AtgJzkJqK+8ggdPiPPvX_AVWhsirZRdNLhdAn8qVw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] PCI/ACPI: Move AER severity defines to aer.h
To: Joe Perches <joe@perches.com>
Cc: Betty Dall <betty.dall@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Pearson, Greg" <greg.pearson@hp.com>,
        Huang Ying <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 12:23 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2013-06-06 at 12:10 -0600, Betty Dall wrote:
>> The function aer_recover_queue() is a public interface and the
>> severity argument uses #defines that are in the private header
>> pci/pcie/aer/aerdrv.h.
>>
>> This patch moves the #defines from pci/pcie/aer/aerdrv.h to
>> include/linux/aer.h.
> []
>> diff --git a/include/linux/aer.h b/include/linux/aer.h
> []
>> -extern void cper_print_aer(const char *prefix, struct pci_dev *dev,
>> +void cper_print_aer(const char *prefix, struct pci_dev *dev,
>>                          int cper_severity, struct aer_capability_regs *aer);
>
> Can you please also realign the arguments on subsequent
> lines to the open parenthesis of the first line and reflow
> then to 80 cols when appropriate?

I can do this when I apply them, so don't bother reposting unless you
have more substantive changes to make.

>> -extern void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
>> +void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
>>                             int severity);
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3FYRfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:35:13 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43854 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3FYRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130620125120.GP2575@8bytes.org>
References: <CAErSpo7onNaU5mquJ_a7kwGPgzs3Q_7U89__HT9DbJFkUX4fsQ@mail.gmail.com>
 <20130529083652.GA25971@dhcp-26-207.brq.redhat.com> <CAErSpo4EkXX-UoFLyni+ZpXaTmCRq5sJCqZ4FCt7fywpDyVWqw@mail.gmail.com>
 <CAErSpo6bjBEK=Ta=pVzwCBMfrqfe3jB-sEfv1Kz9mt9iakdeaA@mail.gmail.com> <20130620125120.GP2575@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Jun 2013 11:34:49 -0600
Message-ID: <CAErSpo5AD0aQtc-EWCQHcviXv-xyC=Gn6Lii8a5MdtFOvpe59w@mail.gmail.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
To: Joerg Roedel <joro@8bytes.org>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 6:51 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Mon, Jun 03, 2013 at 02:46:59PM -0600, Bjorn Helgaas wrote:
>> I pushed these with updates to
>> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/alexander-msi
>>
>> Anybody want to ack the iommu/irq_remapping.c patch?  If so, I can
>> merge that branch into -next for v3.11.
>
> Sorry for being unresponsive, things habe been pretty busy here :-(
> The changes look good, you have my
>
> Acked-by: Joerg Roedel <joro@8bytes.org>

No problem, thanks!  I added your ack and merged to my -next branch for v3.11.

Bjorn

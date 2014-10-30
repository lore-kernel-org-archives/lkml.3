Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372AbaJ3T1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:27:37 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:37410 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbaJ3T1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVU7F=MXUVEwmemz61=TbL5imFecHexUik+3DtqWKOHGA@mail.gmail.com>
References: <1414621570-20777-1-git-send-email-yinghai@kernel.org>
 <20141030170913.GA6982@google.com> <CAE9FiQVU7F=MXUVEwmemz61=TbL5imFecHexUik+3DtqWKOHGA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 30 Oct 2014 13:27:15 -0600
Message-ID: <CAErSpo4E+ObyKb8wggT6rKQsT+VCXyoY4xqSFHitgq2bkSk6Pg@mail.gmail.com>
Subject: Re: [PATCH] PCI: fix sriov enabling with virtual bus
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Oct 30, 2014 at 10:09 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:

>>> Fixing: commit 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")
>>
>> Thanks for including this, but why not use the same format everybody else
>> does:
>>
>> Fixes: 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")
>
> will do that later. Is that formalized ?

I don't know that it's formalized, but it seems to be a common
convention, and using "Fixing: commit" instead of "Fixes:" doesn't
seem to add value.  I guess I must spend more time reading git
logs than most people :)

> checkpatch.pl only need 12 commit code, and (" ..") format.

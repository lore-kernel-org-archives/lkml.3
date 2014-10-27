Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaJ0NVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:21:36 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:55114 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaJ0NVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141027025531.GB5149@hr-slim.amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-3-git-send-email-ray.huang@amd.com> <20141024163529.GA7075@google.com>
 <20141027025531.GB5149@hr-slim.amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Oct 2014 07:21:10 -0600
Message-ID: <CAErSpo6qdkteY=UW-f23vOHwYj0x+yheno-_XvLerdB2W5wA8w@mail.gmail.com>
Subject: Re: [PATCH v2 02/16] pci: quirks: add quirk to avoid AMD NL to bind
 with xhci
To: Huang Rui <ray.huang@amd.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 8:55 PM, Huang Rui <ray.huang@amd.com> wrote:
> On Fri, Oct 24, 2014 at 10:35:29AM -0600, Bjorn Helgaas wrote:
>> On Fri, Oct 17, 2014 at 04:53:27PM +0800, Huang Rui wrote:

>> > +/* FIXME should define in <linux/pci_ids.h> */
>> > +#define PCI_DEVICE_ID_AMD_NL       0x7912
>>
>> If you KNOW this should be in linux/pci_ids.h (and it looks like it COULD
>> go there, since you do use the same definition in patch [01/16]), why don't
>> you just do it?  Why are you wasting our time reviewing trivial stuff like
>> this?
>>
>
> Apology, I was told that it could not add device id into pci_ids.h
> from my buddy with below thread discussion last year, but I don't
> confirm at current. I check the git log at pci_ids.h, it looks like
> it's able to add device id marco again, is that right?
>
> http://marc.info/?l=linux-pci&m=137028614924258&w=2
>
> If I misunderstand your meaning, please correct me.

Just read the text at the beginning of pci_ids.h.

If you have to use the same ID in two different files, you should add
it to pci_ids.h.

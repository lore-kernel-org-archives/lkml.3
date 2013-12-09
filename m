Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab3LIUr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:47:27 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60999 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3LIUrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:47:24 -0500
MIME-Version: 1.0
In-Reply-To: <20131209204323.GA25180@kroah.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-2-git-send-email-yinghai@kernel.org>
	<CAErSpo7HaAbsoy0n5sr_d3iPazEnpnO8WupJrDn2QR2Kid=EgQ@mail.gmail.com>
	<CAE9FiQUebPPcTyHGssxTwJJ3GYx4aq-=infapvxOQgAm+PL4rA@mail.gmail.com>
	<CAE9FiQUrTAnQkiS9SU3-pJ35-U9CqXQNQEceUUarf-WiPXCF2Q@mail.gmail.com>
	<20131209204323.GA25180@kroah.com>
Date: Mon, 9 Dec 2013 12:47:24 -0800
X-Google-Sender-Auth: Es4gDo8u7iiyV7kQcoyq1Yu7f1k
Message-ID: <CAE9FiQW60hW06sr=ahV6rEMRQ5kA04A_1mUtfZQAra__6ttNxw@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: pcibus address to resource converting take bus
 instead of dev
From: Yinghai Lu <yinghai@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 12:43 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 09, 2013 at 12:03:18PM -0800, Yinghai Lu wrote:
>> On Mon, Dec 9, 2013 at 11:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Mon, Dec 9, 2013 at 9:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >>
>> >> Ugh.  Why would we add new functions with "__" prefixes?  There are
>> >> only a handful of callers to pcibios_bus_to_resource() and
>> >> pcibios_resource_to_bus().  We can just change them to supply a
>> >> "struct pci_bus *" directly.  That's a better match for how the
>> >> hardware works anyway.
>> >
>>
>> Please double check if you are happy with the change.
>> Hope that will not update stable tree maintainer guys.
>
> What do you mean by this?

Do not want to change too much code, to upset stable tree maintainers.

>
> How is this a -stable kernel patch?

We have stable patch that will need use the new function.

[PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio

Thanks

Yinghai

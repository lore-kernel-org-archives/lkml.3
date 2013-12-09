Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3LIUmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:42:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab3LIUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:41:58 -0500
Date: Mon, 9 Dec 2013 12:43:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] PCI: pcibus address to resource converting take bus
 instead of dev
Message-ID: <20131209204323.GA25180@kroah.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
 <1386546869-31900-2-git-send-email-yinghai@kernel.org>
 <CAErSpo7HaAbsoy0n5sr_d3iPazEnpnO8WupJrDn2QR2Kid=EgQ@mail.gmail.com>
 <CAE9FiQUebPPcTyHGssxTwJJ3GYx4aq-=infapvxOQgAm+PL4rA@mail.gmail.com>
 <CAE9FiQUrTAnQkiS9SU3-pJ35-U9CqXQNQEceUUarf-WiPXCF2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUrTAnQkiS9SU3-pJ35-U9CqXQNQEceUUarf-WiPXCF2Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 12:03:18PM -0800, Yinghai Lu wrote:
> On Mon, Dec 9, 2013 at 11:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Dec 9, 2013 at 9:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>
> >> Ugh.  Why would we add new functions with "__" prefixes?  There are
> >> only a handful of callers to pcibios_bus_to_resource() and
> >> pcibios_resource_to_bus().  We can just change them to supply a
> >> "struct pci_bus *" directly.  That's a better match for how the
> >> hardware works anyway.
> >
> 
> Please double check if you are happy with the change.
> Hope that will not update stable tree maintainer guys.

What do you mean by this?

How is this a -stable kernel patch?


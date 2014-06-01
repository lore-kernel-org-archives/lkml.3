Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaFAW5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 18:57:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56647 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaFAW5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 18:57:35 -0400
X-Sasl-enc: 04yaVOP3OcVRRuK2TSIz9lBHxNeGhO9igoa8ayTKoIFu 1401663454
Date: Sun, 1 Jun 2014 15:57:30 -0700
From: "greg@kroah.com" <greg@kroah.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "andreas.noever@gmail.com" <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Message-ID: <20140601225730.GA16495@kroah.com>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
 <1401580281.7663.14.camel@x230>
 <CAMxnaaURVhZ_SiJW7Qy1bsye1bcPE=J=vjL5MgTN5znP15WnXw@mail.gmail.com>
 <1401638869.7663.21.camel@x230>
 <CAMxnaaUJKmRrP6f2U+0-BVY_Pgz+qOn1BekGUyOqUPvp33so0w@mail.gmail.com>
 <1401660124.7663.22.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401660124.7663.22.camel@x230>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 10:02:04PM +0000, Matthew Garrett wrote:
> On Sun, 2014-06-01 at 22:45 +0200, Andreas Noever wrote:
> > On Sun, Jun 1, 2014 at 6:07 PM, Matthew Garrett
> > <matthew.garrett@nebula.com> wrote:
> > > Yeah, it seems I don't need the suspend quirk - the NHI is still there
> > > without it. I still think we should make the quirk general rather than
> > > tying it to the machines, the worst case is that it'll just do nothing.
> > Ok, agreed. The "wait" quirk has to run on all machines and the other
> > one will fail if the ACPI methods are not there. Should I resend the
> > series or just the patch or should I (or do you want to) make a
> > separate patch?
> 
> Probably best to ask Greg - I'm fine with this stuff going through his
> tree (note to Greg: the Apple ACPI patches I just sent need to be merged
> before this stuff will work properly)

Ok, I'll still queue these up, I don't want the to be lost at all, and
will wait for the ACPI patches to land before starting to complain that
things don't work on my box :)

thanks,

greg k-h

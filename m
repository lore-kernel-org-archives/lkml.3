Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaKZQjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:39:39 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40301 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaKZQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:39:37 -0500
MIME-Version: 1.0
In-Reply-To: <1408555596.16955.12.camel@hastur.hellion.org.uk>
References: <1408552838-4032-1-git-send-email-konrad.wilk@oracle.com>
 <1408552838-4032-2-git-send-email-konrad.wilk@oracle.com> <1408555132.16955.5.camel@hastur.hellion.org.uk>
 <20140820172029.GA5089@laptop.dumpdata.com> <1408555596.16955.12.camel@hastur.hellion.org.uk>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 26 Nov 2014 11:39:16 -0500
X-Google-Sender-Auth: jxw6Sc4rdLjyUywu7hhHdb1yX84
Message-ID: <CAB=NE6VS9hbk4nTRM7Gw_K6TChiEzDPoPGQ616EK68ASCN8BXQ@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen-pciback: Add MODULE_ALIAS for pciback.
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 1:26 PM, Ian Campbell <ian.campbell@citrix.com> wrote:
> On Wed, 2014-08-20 at 13:20 -0400, Konrad Rzeszutek Wilk wrote:
>> On Wed, Aug 20, 2014 at 06:18:52PM +0100, Ian Campbell wrote:
>> > On Wed, 2014-08-20 at 12:40 -0400, Konrad Rzeszutek Wilk wrote:
>> > > The rest of the Xen device drivers use an module alias
>> > > to load devices when they shop up in XenBus.
>> >
>> > "show".
>> > >
>> > >  MODULE_LICENSE("Dual BSD/GPL");
>> > >  MODULE_ALIAS("xen-backend:pci");
>> > > +MODULE_ALIAS("xen:pci");
>> >
>> > Isn't that xen-backend:pci already the right thing for a backend device?
>> > xen: is for frontends, I thought.
>>
>> Oh, you are right. Cool! Thanks!
>
> The patch turned out to be even more trivial than expected ;-)

Is this what we expected to be pending work for the item "device
hotplug (MODULE_ALIAS)" on the upstream TODO list?

http://wiki.xenproject.org/wiki/XenParavirtOps#Upstream_delta_details

This was simply to just auto load that driver when needed right?

Also as for actual PCI device hotplug support:

http://wiki.xen.org/wiki/Xen_PCI_Passthrough#Hotplug

I don't think we need a delta for that do we?

 Luis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbaIWWHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:07:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54647 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaIWWHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:07:22 -0400
Date: Tue, 23 Sep 2014 15:07:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatjain@juniper.net>,
        Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "rajatxjain@gmail.com" <rajatxjain@gmail.com>
Subject: Re: [PATCH] PCI: Prevent NULL dereference during pciehp probe
Message-ID: <20140923220717.GA16279@roeck-us.net>
References: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
 <580c2c85f8424369910b69a8f871f82e@DM2PR05MB671.namprd05.prod.outlook.com>
 <20140923215509.GB15481@roeck-us.net>
 <CAErSpo6dEevVxCS2bqq=+_99uLvN0tccbAdvH2cn12xRVSv2oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6dEevVxCS2bqq=+_99uLvN0tccbAdvH2cn12xRVSv2oQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:04:42PM -0600, Bjorn Helgaas wrote:
> On Tue, Sep 23, 2014 at 3:55 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Mon, Sep 15, 2014 at 10:20:41PM +0000, Rajat Jain wrote:
> >> Hello Bjorn,
> >>
> >> I think this patch needs to be applied to all -stable branches (all the way back to 3.2).
> >>
> >> I encounter this same issue on my platform that is running 3.14.y.
> >>
> > Bjorn,
> >
> > can you send this to -stable, or is it ok if I do it ?
> 
> I forgot to mention it, but I did mark it for stable, so it should
> happen automatically:
> 
> https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/hotplug&id=bceee4a97eb58bd0e80e39eff11b506ddd9e7ad3

Ah, sorry, I didn't realize that.

Thanks,
Guenter

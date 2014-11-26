Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaKZRTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:19:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43559 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:19:02 -0500
Message-Id: <201411261718.sAQHIsgd027807@aserz7022.oracle.com>
Date: Wed, 26 Nov 2014 12:18:48 -0500
Subject: Re: [Xen-devel] [PATCH] xen-pciback: Add MODULE_ALIAS for pciback.
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAQHJBv7017791


On Nov 26, 2014 11:39 AM, "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>
> On Wed, Aug 20, 2014 at 1:26 PM, Ian Campbell <ian.campbell@citrix.com> wrote: 
> > On Wed, 2014-08-20 at 13:20 -0400, Konrad Rzeszutek Wilk wrote: 
> >> On Wed, Aug 20, 2014 at 06:18:52PM +0100, Ian Campbell wrote: 
> >> > On Wed, 2014-08-20 at 12:40 -0400, Konrad Rzeszutek Wilk wrote: 
> >> > > The rest of the Xen device drivers use an module alias 
> >> > > to load devices when they shop up in XenBus. 
> >> > 
> >> > "show". 
> >> > > 
> >> > >Â  MODULE_LICENSE("Dual BSD/GPL"); 
> >> > >Â  MODULE_ALIAS("xen-backend:pci"); 
> >> > > +MODULE_ALIAS("xen:pci"); 
> >> > 
> >> > Isn't that xen-backend:pci already the right thing for a backend device? 
> >> > xen: is for frontends, I thought. 
> >> 
> >> Oh, you are right. Cool! Thanks! 
> > 
> > The patch turned out to be even more trivial than expected ;-) 
>
> Is this what we expected to be pending work for the item "device 
> hotplug (MODULE_ALIAS)" on the upstream TODO list? 
>
> http://wiki.xenproject.org/wiki/XenParavirtOps#Upstream_delta_details 
>
> This was simply to just auto load that driver when needed right? 
>

Right which it does now.

> Also as for actual PCI device hotplug support: 
>
> http://wiki.xen.org/wiki/Xen_PCI_Passthrough#Hotplug 
>
> I don't think we need a delta for that do we? 

Nope. This one is all done.
>
> Luis 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

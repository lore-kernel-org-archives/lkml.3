Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaLDMGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:06:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21628 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbaLDMGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:06:47 -0500
Message-Id: <201412041206.sB4C6XVQ009497@userz7022.oracle.com>
Date: Thu, 04 Dec 2014 07:06:24 -0500
Subject: Re: [PATCH v5 9/9] xen/pciback: Implement PCI reset slot or bus
 with 'do_flr' SysFS attribute
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-pci@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB4C748E001308


On Dec 4, 2014 6:30 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>
> On 03/12/14 21:40, Konrad Rzeszutek Wilk wrote: 
> > 
> > Instead of doing all this complex dance, we depend on the toolstack 
> > doing the right thing. As such implement the 'do_flr' SysFS attribute 
> > which 'xl' uses when a device is detached or attached from/to a guest. 
> > It bypasses the need to worry about the PCI lock. 
>
> No.Â  Get pciback to add its own "reset" sysfs file (as I have repeatedly 
> proposed). 
>

Which does not work as the kobj will complain (as there is already an 'reset' associated with the PCI device).

Unless you mean an different name (reset2).

> David 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3LBXwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:52:19 -0500
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:50911 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750938Ab3LBXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:52:15 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3770:3865:3866:3868:3870:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4423:5007:7652:9025:9388:10004:10049:10400:10848:11026:11232:11473:11658:11914:12043:12114:12438:12517:12519:12679:12740:13069:13161:13200:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glass27_3058e7ee4fe05
X-Filterd-Recvd-Size: 1489
Message-ID: <1386028330.15309.13.camel@joe-AO722>
Subject: Re: [PATCH 38/39] PCI: remove DEFINE_PCI_DEVICE_TABLE macro
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Date: Mon, 02 Dec 2013 15:52:10 -0800
In-Reply-To: <003b01ceefb6$bca43ed0$35ecbc70$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	 <003b01ceefb6$bca43ed0$35ecbc70$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 08:32 +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred. Also, the definition of DEFINE_PCI_DEVICE_TABLE
> macro is removed.

These sorts of treewide conversions are almost never
applied wholesale.

This patch is not appropriate until there are no more
uses of DEFINE_PCI_DEVICE_TABLE in Linus' tree.

Just marking the function as deprecated in the
documentation and the pci.h file is probably good
enough for now.

see:  http://lkml.org/lkml/2013/12/2/400



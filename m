Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3JIVLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:11:09 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:42457 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753550Ab3JIVLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:11:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3865:3867:3870:3873:3874:4321:5007:7652:10004:10400:10848:11232:11657:11658:11914:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ocean03_972a9a59fa30
X-Filterd-Recvd-Size: 1509
Message-ID: <1381353063.2050.24.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Add arch/x86/pci to PCI file patterns
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Oct 2013 14:11:03 -0700
In-Reply-To: <20131009210219.31110.62076.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131009210219.31110.62076.stgit@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Bjorn

On Wed, 2013-10-09 at 15:02 -0600, Bjorn Helgaas wrote:
> I handle many arch/x86/pci changes, so help those patches get to the
> PCI patchwork.

[]
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e61c2e8..d1ab647 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6338,6 +6338,7 @@ S:	Supported
>  F:	Documentation/PCI/
>  F:	drivers/pci/
>  F:	include/linux/pci*
> +F:	arch/x86/pci/*

This could be

F:	arch/x86/pci/

so that if anyone ever sticks a subdirectory
in there, you'd still get notified.



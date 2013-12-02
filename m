Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3LBSHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:07:51 -0500
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:41600 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752914Ab3LBSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:07:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3653:3865:3866:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12114:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shock18_607fa3dc96b3b
X-Filterd-Recvd-Size: 1850
Message-ID: <1386007657.2680.15.camel@joe-AO722>
Subject: Re: [PATCH] pci/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jonas Bonn <jonas@southpole.se>, Jingoo Han <jg1.han@samsung.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org
Date: Mon, 02 Dec 2013 10:07:37 -0800
In-Reply-To: <20131202180147.GB31606@roeck-us.net>
References: <1385617213.12210.5.camel@joe-AO722>
	 <20131128055328.GA565@kroah.com> <1385619863.12210.14.camel@joe-AO722>
	 <529C026E.2000302@roeck-us.net>
	 <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>
	 <529C04C7.9050506@roeck-us.net>
	 <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com>
	 <1385963295.2680.2.camel@joe-AO722> <529C6495.3020305@southpole.se>
	 <1386006217.2680.13.camel@joe-AO722> <20131202180147.GB31606@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 10:01 -0800, Guenter Roeck wrote:
> On Mon, Dec 02, 2013 at 09:43:37AM -0800, Joe Perches wrote:
> > Prefer use of the direct definition of struct pci_device_id
[]
> > +all-zero entry.  Definitions with static const are generally preferred.

see here:

> Add 'const' ?

Also see $fix.

Not all can be const as some codes actually modify
the tables for various quirks.



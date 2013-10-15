Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab3JOQm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:42:26 -0400
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:43417 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932439Ab3JOQmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:42:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3167:3622:3867:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: milk54_31de830ac701c
X-Filterd-Recvd-Size: 1653
Message-ID: <1381855341.22110.21.camel@joe-AO722>
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output
 format
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@gmail.com>, Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Lance Ortiz <lance.ortiz@hp.com>
Date: Tue, 15 Oct 2013 09:42:21 -0700
In-Reply-To: <20131015122958.GD7908@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	 <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
	 <20131011160208.GL5925@pd.tnic> <20131014045500.GC12189@gchen.bj.intel.com>
	 <20131014103616.GE4009@pd.tnic>
	 <CA+8MBbJ9P1GVf3SCh7LMY_LH+pxQg3GWkxKMzni1b1Wyx1o8NQ@mail.gmail.com>
	 <525D2A07.6080201@linux.vnet.ibm.com> <20131015122958.GD7908@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 14:29 +0200, Borislav Petkov wrote:
> Once we exposed it to userspace, we cannot simply assume
> that nothing is using it.

Yes, we can.

No guarantees are made about dmesg output.

If guarantees were made, no typo could ever be fixed
nor could any conversion from printk to dev_<level>
be done.


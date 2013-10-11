Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3JKBHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:07:31 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:48267 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755146Ab3JKBH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:07:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3873:3874:4321:5007:7652:9010:10004:10400:10848:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wrist52_53f95dd0a1e2c
X-Filterd-Recvd-Size: 1593
Message-ID: <1381453575.14017.26.camel@joe-AO722>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 Oct 2013 18:06:15 -0700
In-Reply-To: <CA+55aFyDiF43Oawdsb6EPhsdrLZS_L3PCj5fRJsEqRAnVW8Jgg@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home>
	 <CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
	 <81272921.7ZJW2CaxNE@vostro.rjw.lan>
	 <CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
	 <20131010201909.5d83cf36@gandalf.local.home>
	 <CA+55aFyDiF43Oawdsb6EPhsdrLZS_L3PCj5fRJsEqRAnVW8Jgg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 18:00 -0700, Linus Torvalds wrote:
> the first step is to realize you have a problem.

Says the guy that can only send patches to the list
as attachments not plain text because he uses gmail.


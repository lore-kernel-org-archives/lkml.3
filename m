Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3LSReh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:34:37 -0500
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:36820 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751682Ab3LSRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:34:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3770:3865:3867:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6691:7652:8985:9025:9388:10004:10049:10400:10848:11232:11658:11914:12043:12517:12519:12663:12740:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: start94_44f99eea3345d
X-Filterd-Recvd-Size: 1442
Message-ID: <1387474472.2353.10.camel@joe-AO722>
Subject: Re: Lindent formatting issues
From: Joe Perches <joe@perches.com>
To: Laszlo Papp <lpapp@kde.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 19 Dec 2013 09:34:32 -0800
In-Reply-To: <CAOMwXhPceCtCRvD8i7VO=QOuDX=M0gQuERwTConkrF9ohPfs=g@mail.gmail.com>
References: <CAOMwXhPPN2h2boAOn1=BaHuWa+9nYw=oe1u1bYHtHGyad9Kw8A@mail.gmail.com>
	 <1387310726.8859.5.camel@joe-AO722>
	 <CAOMwXhNVJ8HPCe6t=VkCthEiOqNtOczz5Xqy_ciM7rsqWRVOYw@mail.gmail.com>
	 <1387470731.2353.7.camel@joe-AO722>
	 <CAOMwXhPceCtCRvD8i7VO=QOuDX=M0gQuERwTConkrF9ohPfs=g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 17:30 +0000, Laszlo Papp wrote:
> On Thu, Dec 19, 2013 at 4:32 PM, Joe Perches <joe@perches.com> wrote:

> > Is this change from Lindent or checkpatch?
> 
> I have used Lindent when these lines were generated. Here is some more:

I am not a Lindent / indent maintainer.

My suggestion remains not to use Lindent.

I _have_ suggested that Lindent be removed from the kernel.

http://lkml.org/lkml/2013/2/11/390



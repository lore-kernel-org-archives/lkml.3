Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbaFZRiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:38:12 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:40893 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756633AbaFZRiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:38:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2915:3138:3139:3140:3141:3142:3622:3865:3866:3867:3871:3872:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13071:13161:13229:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: back38_29f1dfdd87b0e
X-Filterd-Recvd-Size: 1157
Message-ID: <1403804286.7977.58.camel@joe-AO725>
Subject: Re: [PATCH] HID: roccat: Drop cast
From: Joe Perches <joe@perches.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Thu, 26 Jun 2014 10:38:06 -0700
In-Reply-To: <20140626172852.GA2878@himangi-Dell>
References: <20140626172852.GA2878@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 22:58 +0530, Himangi Saraogi wrote:
> This patch removes the cast on data of type void* as it is not needed.

Hi Himangi

The cast of a const void * to a void * was odd.

Maybe a mechanism to verify appropriateness of
loss of constness for any pointer might be useful.



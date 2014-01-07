Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaAGRsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:48:50 -0500
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:32886 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752366AbaAGRsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:48:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2538:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3870:3871:3872:3874:4250:4321:5007:6119:6120:7652:7901:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sea37_85b5fc25e410b
X-Filterd-Recvd-Size: 1369
Message-ID: <1389116918.32137.16.camel@joe-AO722>
Subject: Re: [PATCH v2] checkpatch: Only flag FSF address, not gnu.org URL
From: Joe Perches <joe@perches.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@linuxfoundation.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Jan 2014 09:48:38 -0800
In-Reply-To: <20140107173926.8923.98340.stgit@ahduyck-cp2.jf.intel.com>
References: <20140107173926.8923.98340.stgit@ahduyck-cp2.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 09:41 -0800, Alexander Duyck wrote:
> This change restricts the check for the for the FSF address in the GPL
> copyright statement so that it only flags the address, not the references to
> the gnu.org/licenses URL which appears to be used in numerous drivers.  The
> idea is to still allow some reference to an external copy of the GPL in the
> event that files are copied out of the kernel tree without the COPYING file.

Looks OK to me.



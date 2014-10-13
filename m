Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaJMUvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:51:18 -0400
Received: from smtprelay0247.hostedemail.com ([216.40.44.247]:50568 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751429AbaJMUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:51:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1559:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3868:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8784:8957:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pear85_44658908a8101
X-Filterd-Recvd-Size: 1026
Message-ID: <1413233468.1287.27.camel@joe-AO725>
Subject: Re: [PATCH 1/1 linux-next] fs/affs/amigaffs.c: use va_format
 instead of buffer/vnsprintf
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 13 Oct 2014 13:51:08 -0700
In-Reply-To: <1413232777-11062-1-git-send-email-fabf@skynet.be>
References: <1413232777-11062-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 22:39 +0200, Fabian Frederick wrote:
> Remove ErrorBuffer and use %pV

Maybe fix the format/argument mismatches too.

https://lkml.org/lkml/2010/11/10/544



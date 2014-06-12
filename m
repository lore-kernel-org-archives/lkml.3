Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbaFLRfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:35:11 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:45665 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933092AbaFLRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:35:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:901:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7576:7652:9025:9072:9388:10004:10049:10400:10848:11232:11257:11658:11914:12043:12296:12517:12519:12679:12740:13019:13069:13161:13200:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: debt02_494ad2fa2df3b
X-Filterd-Recvd-Size: 1767
Message-ID: <1402594501.12385.10.camel@joe-AO725>
Subject: Re: [PATCH 2/2] Documentation: exceptions to what I maintain
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jun 2014 10:35:01 -0700
In-Reply-To: <5399DF99.2010701@infradead.org>
References: <5399DF99.2010701@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 10:12 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Note that I don't maintain Documentation/ABI/,
> Documentation/devicetree/, or the language translation files.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Hey Randy.

Perhaps it's better to use exclusion "X:" values
so get_maintainer doesn't still include you.

> @@ -2885,7 +2885,7 @@ M:	Randy Dunlap <rdunlap@infradead.org>
>  L:	linux-doc@vger.kernel.org
>  T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
>  S:	Maintained
> -F:	Documentation/
> +F:	Documentation/ (but not: ABI, devicetree, translations)

Maybe:

X:	Documentation/ABI/
X:	Documentation/devicetree/
X:	Documentation/[a-z][a-z]_[A-Z][A-Z]/

The last line matches:

Documentation/ja_JP/
Documentation/ko_KR/
Documentation/zh_CN/

and it's easy to add any other directory you don't
want to cc'd on.




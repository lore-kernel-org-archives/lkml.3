Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaEZR2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:28:15 -0400
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:55769 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751308AbaEZR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:28:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3870:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13163:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chin84_2a6a6f03fa513
X-Filterd-Recvd-Size: 1700
Message-ID: <1401125290.519.18.camel@joe-AO725>
Subject: Re: [PATCH 1/3] staging: panel: (coding style) Matching braces
From: Joe Perches <joe@perches.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Dominique van den Broeck <domdevlin@free.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 10:28:10 -0700
In-Reply-To: <20140526142827.GG13929@1wt.eu>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
	 <20140526142827.GG13929@1wt.eu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 16:28 +0200, Willy Tarreau wrote:
> I believe that most of the kernel code prefers the two-line format resluting
> in this instead :
> 
> 		}
> 		else if (*esc >= 'A' && *esc <= 'Z') {
> 			value |= (*esc - 'A' + 10) << shift;
> 		}
> 		else if (*esc >= 'a' && *esc <= 'z') {
> 			value |= (*esc - 'a' + 10) << shift;
> 		}
> 		else {

grep shows what kernel style is most used.

Your form:
	}
	else if (...) {

(This shows 3 lines per instance)
$ grep-2.5.4 -rP --include=*.[ch] '}\n[ \t]*else if.*{\n' * | wc -l
909

Generally used form:
	} else if (...) {

(mostly shows 2 lines per instance)
$ grep-2.5.4 -rP --include=*.[ch] '} else if.*{\n' * | wc -l
31653

That's ~50:1 preference for "} else if (...) {"

> It's just a matter of taste I know,

true enough.



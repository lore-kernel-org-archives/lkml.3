Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab3IPPJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:09:55 -0400
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:42068 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755282Ab3IPPJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:09:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3622:3866:3867:4321:5007:6642:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13160:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: farm61_1b7bbcce35145
X-Filterd-Recvd-Size: 1478
Message-ID: <1379344187.1934.1.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>,
        George Spelvin <linux@horizon.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 16 Sep 2013 08:09:47 -0700
In-Reply-To: <CAGXu5jJErvcfdq0=QDd2pwCeK7kKnJ-GY2ybv9ssdkF6NjNvDw@mail.gmail.com>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	 <1379317437-28329-2-git-send-email-keescook@chromium.org>
	 <201309162041.HHG69783.FLFMJFtSOQOHVO@I-love.SAKURA.ne.jp>
	 <CAGXu5jJErvcfdq0=QDd2pwCeK7kKnJ-GY2ybv9ssdkF6NjNvDw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 07:59 -0700, Kees Cook wrote:
> Perhaps instead of seq->count, there should be an access function?
> seq_get_count(seq) or something?

My thought was to add a seq_last_len()




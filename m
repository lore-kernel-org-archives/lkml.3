Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3ITEXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 00:23:12 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:47273 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752166Ab3ITEXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 00:23:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2525:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3
X-HE-Tag: scale96_8fa7026385824
X-Filterd-Recvd-Size: 1927
Message-ID: <1379650985.2021.12.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jslaby@suse.cz, viro@zeniv.linux.org.uk, xemul@openvz.org,
        remi.denis-courmont@nokia.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux@horizon.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com,
        geert@linux-m68k.org, JBeulich@suse.com, kosaki.motohiro@gmail.com
Date: Thu, 19 Sep 2013 21:23:05 -0700
In-Reply-To: <201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
References: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>
	 <20130917205742.16147.qmail@science.horizon.com>
	 <201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>
	 <CAGXu5jK_D1BJOQr=1A-UFrpM5Ad+Qu894HT_XjkZh4EmsbCkTQ@mail.gmail.com>
	 <201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 13:09 +0900, Tetsuo Handa wrote:
> Hello.

Tetsuo-san:

> We are discussing about removal of %n support from vsnprintf() at
> https://lkml.org/lkml/2013/9/16/52 , and you are using %n in seq_printf().

Well, I'm not using (mere alcohol isn't using, right?)
but I still have the same question for Al.

Are there any races here?

> I posted https://lkml.org/lkml/diff/2013/9/19/53/1 which introduces
> seq_setwidth() / seq_pad() which can avoid use of %n in seq_printf().

I still think adding last_len, last_rtn
is sensible.



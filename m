Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3ITTdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:33:23 -0400
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:40104 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753879Ab3ITTdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:33:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2736:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:3874:4321:5007:7652:10004:10400:10848:11
X-HE-Tag: flag11_56f3dd6184131
X-Filterd-Recvd-Size: 2051
Message-ID: <1379705596.2301.17.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@openvz.org>,
        =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont 
	<remi.denis-courmont@nokia.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, George Spelvin <linux@horizon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jan Beulich <JBeulich@suse.com>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>
Date: Fri, 20 Sep 2013 12:33:16 -0700
In-Reply-To: <CAGXu5jLENb+x6b9XOY7-pWMT7GsFgnLr0=A8VNFLkqMi0BX4=w@mail.gmail.com>
References: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>
	 <20130917205742.16147.qmail@science.horizon.com>
	 <201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>
	 <CAGXu5jK_D1BJOQr=1A-UFrpM5Ad+Qu894HT_XjkZh4EmsbCkTQ@mail.gmail.com>
	 <201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
	 <523C0268.20404@suse.cz>
	 <CAGXu5jLENb+x6b9XOY7-pWMT7GsFgnLr0=A8VNFLkqMi0BX4=w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 12:24 -0700, Kees Cook wrote:
> There are a few problems that have been discussed on the various
> threads. Namely, we want to minimize the changes to the seq_file
> structure and to not add additional work to all the seq_file users
> that don't care about padding.

I don't think saving a couple more values to a struct
is that big a deal.



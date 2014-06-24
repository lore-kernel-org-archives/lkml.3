Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaFXU50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:57:26 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:56441 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754477AbaFXU5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:57:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2689:2693:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:6120:7652:7903:8531:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bird74_4055a3831ec57
X-Filterd-Recvd-Size: 2188
Message-ID: <1403643440.29061.56.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 24 Jun 2014 13:57:20 -0700
In-Reply-To: <CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	 <1403477762.18747.14.camel@joe-AO725>
	 <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	 <1403505219.18747.37.camel@joe-AO725> <87egyeqt03.fsf@rasmusvillemoes.dk>
	 <CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	 <1403638620.29061.35.camel@joe-AO725>
	 <CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	 <1403641843.29061.51.camel@joe-AO725>
	 <CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 22:41 +0200, Mathias Krause wrote:
> there is more to optimize
> if one is patient enough ;)

Ever thus.

> And all of those strings should be in the .rodata section, now. But
> why you're asking?

Because now they will be duplicated in .rodata
and the __init section no?

> Yes. My vanilla vmlinux build has quite a lot of copies of "off" in
> it. But I doubt any linker would merge those. Does LTO do so?

I would expect that duplicated strings in
separate sections would not be merged.



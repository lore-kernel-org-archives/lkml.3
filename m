Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaB0VAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:00:46 -0500
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:56162 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbaB0VAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:00:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3871:3873:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun08_7aa2bbc39234e
X-Filterd-Recvd-Size: 1874
Message-ID: <1393534841.24588.131.camel@joe-AO722>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: Joe Perches <joe@perches.com>
To: Christopher Li <sparse@chrisli.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ben Pfaff <blp@nicira.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 27 Feb 2014 13:00:41 -0800
In-Reply-To: <CANeU7QnB1Yfd6SjLeUmB1Q-a+U6G221J8es7ckfjB-U45sAVMA@mail.gmail.com>
References: <1393462087.24588.50.camel@joe-AO722>
	 <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722>
	 <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722>
	 <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com>
	 <1393472326.24588.82.camel@joe-AO722> <20140227040050.GA8449@nicira.com>
	 <530EBCED.9020705@zytor.com> <20140227042636.GA9592@nicira.com>
	 <530EBFC7.9030309@zytor.com>
	 <CANeU7Q=RNXR00bQcPzJYTOcZmRSn3U31ZcadPTHu6Y_Uk0UnYw@mail.gmail.com>
	 <faa9e231-d561-417b-8b8b-95192cb0e56a@email.android.com>
	 <CANeU7QnB1Yfd6SjLeUmB1Q-a+U6G221J8es7ckfjB-U45sAVMA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 12:44 -0800, Christopher Li wrote:
> On Thu, Feb 27, 2014 at 12:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > I would.
> Joe, I assume you are OK with this patch, the default is now off.

Of course

> diff --git a/lib.c b/lib.c
[]
> @@ -226,6 +226,7 @@ int Wparen_string = 0;
> +int Wsizeof_bool = 0;



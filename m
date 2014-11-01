Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbaKAR5j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 13:57:39 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:35761 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758762AbaKAR5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 13:57:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3865:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6261:7903:9025:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13095:13311:13357:14096:14097:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burn50_5f70a2ad0572e
X-Filterd-Recvd-Size: 1882
Message-ID: <1414864654.31550.6.camel@perches.com>
Subject: Re: [PATCH] x86, cpu: trivial printk formatting fixes
From: Joe Perches <joe@perches.com>
To: Steven Honeyman <stevenhoneyman@gmail.com>,
        Len Brown <len.brown@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Kosina <trivial@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Nov 2014 10:57:34 -0700
In-Reply-To: <CABz95_BFew81JGAf=oP=6m9yPMi1_JmvfjKgX2CxFmha52A54w@mail.gmail.com>
References: <1414856696-8094-1-git-send-email-stevenhoneyman@gmail.com>
	 <20141101171909.GA5034@pd.tnic>
	 <CABz95_BFew81JGAf=oP=6m9yPMi1_JmvfjKgX2CxFmha52A54w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Len Brown, original post: https://lkml.org/lkml/2014/11/1/67)

On Sat, 2014-11-01 at 17:38 +0000, Steven Honeyman wrote:
> On 1 November 2014 17:17, Joe Perches <joe@perches.com> wrote:
> > This changes the logging level.
> >
> > You should either mention why in the changelog
> > or use pr_warn_once
> 
> OK, I will resubmit with a new description if needed.
> Would you agree that info is a more suitable log level than warn for
> this message? Even notice seemed too much, as it isn't a 'significant
> 	condition'

This is only emitted when the bios didn't do the "right thing".
See commit abe48b108247e9b90

So it seems more like the origial message isn't descriptive
enough than KERN_WARN is not the correct level.



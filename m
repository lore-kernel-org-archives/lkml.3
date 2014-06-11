Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaFKCui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:50:38 -0400
Received: from smtprelay0168.hostedemail.com ([216.40.44.168]:60975 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751634AbaFKCuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:50:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2525:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:7652:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drink48_527ca6b89944
X-Filterd-Recvd-Size: 1605
Message-ID: <1402455034.2719.3.camel@joe-AO725>
Subject: Re: [PATCH] x86/tlb_uv: Fixing some memory allocation failure in
 x86 UV
From: Joe Perches <joe@perches.com>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@redhat.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, cpw@sgi.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Date: Tue, 10 Jun 2014 19:50:34 -0700
In-Reply-To: <CAABZP2xD4zRX78HxK1DB+13s+1bo=Ai2x+uJDhtJjb+nkZ7epQ@mail.gmail.com>
References: <1402385723-23138-1-git-send-email-zhouzhouyi@gmail.com>
	 <53978E9F.1010003@zytor.com> <alpine.DEB.2.10.1406110111300.5170@nanos>
	 <CAABZP2xD4zRX78HxK1DB+13s+1bo=Ai2x+uJDhtJjb+nkZ7epQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 09:46 +0800, Zhouyi Zhou wrote:
> Thanks for reviewing, I will work on a new version

If you do, please remove the "out of memory" messages.

These messages are redundant to a generic OOM and
stack dump from the memory subsystem.

Less code is also makes it less likely to have an OOM.

btw: I added a new checkpatch test based on your patch.

https://lkml.org/lkml/2014/6/10/382



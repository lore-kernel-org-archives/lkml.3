Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaAURYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:24:39 -0500
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:44465 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755209AbaAURYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:24:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4362:4552:5007:6117:7652:7875:7903:8957:9010:9389:10004:10400:10848:11232:11658:11914:12048:12114:12296:12517:12519:12679:12740:13161:13229:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck
X-HE-Tag: humor31_a5166c9b4c4b
X-Filterd-Recvd-Size: 3119
Message-ID: <1390325069.2472.78.camel@joe-AO722>
Subject: Re: [tip:core/urgent] MAINTAINERS: Restore "L:
 linux-kernel@vger.kernel.org" entries
From: Joe Perches <joe@perches.com>
To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Tue, 21 Jan 2014 09:24:29 -0800
In-Reply-To: <tip-62f45f9a202c318fd5fb43cd40ef687b7dd2825f@git.kernel.org>
References: <tip-62f45f9a202c318fd5fb43cd40ef687b7dd2825f@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 07:49 -0800, tip-bot for Ingo Molnar wrote:

> MAINTAINERS: Restore "L: linux-kernel@vger.kernel.org" entries
> 
> A couple of years ago all the "L: lkml" email list entries in
> MAINTAINERS were removed and replaced with a 'the rest' entry
> at the end of the file - under the theory that this is unnecessary
> duplication and that people would find it intuitive:

You are politicking with the commentary.
Intuition had nothing to do with the removal,

The idea was to avoid having an L: lkml line for
each of more than 1200 sections so people wouldn't
think that any section that didn't have an lkml
entry shouldn't need to have lkml on the cc list
for a patch.

Also, SubmittingPatches had and still has:

	6) Select your CC (e-mail carbon copy) list.

	Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.

Arguably, that same info should be added to the
MAINTAINERS header instead of each section.

>   b5472cddbe2c MAINTAINERS: remove L: linux-kernel@vger.kernel.org from all but "THE REST"
> 
> So it turns out that it's all but intuitive, not all people
> use scripts/get_maintainer.pl to extract maintainer contact info,
> some people read the MAINTAINERS file and see the lack of 'L:' entries
> of various lkml-only subsystems and are sending patches to the
> maintainers only, without Cc:-ing lkml.  They arguably have a point.

shrug,  I think it would be better if people
used get_maintainer more often.

MAINTAINERS already says:

	PLEASE CC: the maintainers and mailing lists that are generated
	by scripts/get_maintainer.pl.

Maybe duplicating the SubmittingPatches block into
the MAINTAINERS intro is good enough.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -4655,6 +4657,7 @@ F:	net/irda/
>  IRQ SUBSYSTEM
>  M:	Thomas Gleixner <tglx@linutronix.de>
>  S:	Maintained
> +L:	linux-kernel@vger.kernel.org

If this is done, can you please standardize on
placing the L: line immediately after the M: line
and before the S: line as was done for all the
other added lines.

Thanks.


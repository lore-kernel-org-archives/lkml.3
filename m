Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935208AbaGYVuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:50:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42156 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760273AbaGYVuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:50:14 -0400
Date: Fri, 25 Jul 2014 18:50:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140725185005.6b5230f9@recife.lan>
In-Reply-To: <9f4bd671-cbe0-4e11-997e-e369c52589f9@email.android.com>
References: <20140725122317.4f96c131@canb.auug.org.au>
	<9f4bd671-cbe0-4e11-997e-e369c52589f9@email.android.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 25 Jul 2014 07:25:05 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Mauro,
> 
> On July 25, 2014 4:23:17 AM CEST, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >Hi Mauro,
> >
> >After merging the v4l-dvb tree, today's linux-next build (x86_64
> >allmodconfig)
> >failed like this:
> >
> >drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
> >drivers/hid/hid-picolcd_cir.c:117:6: error: 'struct rc_dev' has no
> >member named 'allowed_protos'
> >  rdev->allowed_protos   = RC_BIT_ALL;
> >      ^

Sorry for not noticing. I generally don't do full builds, as doing it
for all archs would require a bigger compilation system than what I
have here. I generally do only partial builds for (almost) all archs
before pushing at linux-next, because it is very hare that a change
on media would break anything outside it.

> I'll have time to look at it on Monday/Tuesday unless you beat me to it.
> 

Well, I can beat you on that ;) it should be allowed_protocols. I'll
fix it here and do a full build to see if you made this mistake on
some other file, as this is the second file where you typed it wrong ;)

Regards,
Mauro

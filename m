Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaKJVFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:05:43 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64953 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbaKJVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:05:41 -0500
Message-ID: <1415653538.21229.37.camel@x220>
Subject: Re: [GIT PULL for v3.18-rc1] media updates
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 22:05:38 +0100
In-Reply-To: <20141110185433.3c53e438@recife.lan>
References: <20141009141849.137e738d@recife.lan>
	 <1413793905.16435.6.camel@x220> <1415652356.21229.31.camel@x220>
	 <20141110185433.3c53e438@recife.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 21:05:39.0176 (UTC) FILETIME=[14852E80:01CFFD2A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 18:54 -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 10 Nov 2014 21:45:56 +0100
> Paul Bolle <pebolle@tiscali.nl> escreveu: 
> > This typo is still present in both next-20141110 and v3.18-rc4. And I've
> > first reported it nearly two months ago. I see two fixes:
> >     1) s/HAS_MMU/MMU/
> >     2) s/ || (COMPILE_TEST && HAS_MMU)//
> > 
> > Which would you prefer?
> 
> Hmm... Probably patchwork didn't get your patch.

There's no patch, not yet. I try to report stuff like this before
sending patches. The idea here being that the people familiar with the
code tend to fix things better and quicker.

> IMHO, the best would be:
> 
> 	depends on HAS_MMU

You really like the HAS_MMU symbol, don't you?

> 	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST

But I understand what you're suggesting here. Should I draft a, probably
untested, patch?


Paul Bolle


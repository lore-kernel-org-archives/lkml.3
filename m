Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaGWLLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:11:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:36483 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaGWLLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:11:11 -0400
Date: Wed, 23 Jul 2014 13:11:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723111110.GT3935@laptop>
References: <53C8E90F.1010306@daenzer.net>
 <53CE00EF.70108@daenzer.net>
 <53CF31AE.30403@daenzer.net>
 <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
 <20140723064948.GK3935@laptop>
 <53CF6CC4.6090207@daenzer.net>
 <20140723082819.GR3935@laptop>
 <20140723092536.GO12054@laptop.lan>
 <53CF80EE.5050702@daenzer.net>
 <53CF844A.5050106@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF844A.5050106@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:45:46AM +0100, Dietmar Eggemann wrote:
> Doesn't the picture showing the captured panic reveal more information.
> Haven't seen it myself, I just saw Peter's reply to your email

Its a general protection fault from somewhere in load_balance(), I send
you the picture.

It would help to get addr2line of the RIP I suppose.

Michel provided a config, so lemme go try and build that, maybe my gcc
will generate similar code to his and the function offset is enough
clue.




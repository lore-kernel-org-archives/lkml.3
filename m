Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbaGWPvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:51:36 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:54339 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbaGWPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140723142454.GQ12054@laptop.lan>
References: <53CF31AE.30403@daenzer.net>
	<CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
	<20140723064948.GK3935@laptop>
	<53CF6CC4.6090207@daenzer.net>
	<20140723082819.GR3935@laptop>
	<20140723092536.GO12054@laptop.lan>
	<53CF80EE.5050702@daenzer.net>
	<53CF844A.5050106@arm.com>
	<20140723111110.GT3935@laptop>
	<20140723113021.GP12054@laptop.lan>
	<20140723142454.GQ12054@laptop.lan>
Date: Wed, 23 Jul 2014 08:51:32 -0700
X-Google-Sender-Auth: PmHEfaJNMbiZe9zABZxEhQppVxc
Message-ID: <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 7:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> No way either of those should generate a #GP. Puzzled.

I haven't seen the full oops, can you forward the screenshot? The
exact register state might give some clues.

             Linus

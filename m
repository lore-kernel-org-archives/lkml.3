Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbaGWSlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:41:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:38285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbaGWSlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:41:13 -0400
Date: Wed, 23 Jul 2014 20:41:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723184111.GG3935@laptop>
References: <20140723113021.GP12054@laptop.lan>
 <20140723142454.GQ12054@laptop.lan>
 <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
 <20140723155526.GW3935@laptop>
 <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
 <20140723170324.GZ3935@laptop>
 <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
 <CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
 <20140723182518.GD3935@laptop>
 <CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:35:06AM -0700, Linus Torvalds wrote:
> But the code does appear to be correct. It just is messy, avoids the
> proper abstractions, and generates suboptimal code for the off-stack
> case.

OK, that leaves us agreeing we want to clean that up, but still no
closer to explaining WTH happened on Michel's machine. Weird that.

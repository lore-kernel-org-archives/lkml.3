Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaJ3FS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 01:18:26 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63222 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaJ3FSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 01:18:24 -0400
Message-ID: <1414646300.5306.22.camel@marge.simpson.net>
Subject: Re: [PATCH] futex: fix a race condition between REQUEUE_PI and task
 death
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Brian Silverman <bsilver16384@gmail.com>, tglx@linutronix.de,
        Austin Schuh <austin.linux@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 30 Oct 2014 06:18:20 +0100
In-Reply-To: <20141030042852.GI14609@vmdeb7>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
	 <CAP01z6LSTyS5FDgZTma96BY5eWycpHgECNwZSy2Afyn2UFH5yA@mail.gmail.com>
	 <20141030042852.GI14609@vmdeb7>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 21:28 -0700, Darren Hart wrote: 
> On Thu, Oct 23, 2014 at 03:28:07PM -0400, Brian Silverman wrote:
> > Here's the test code:
> > 
> 
> I want to say "Thanks!" and pull it into futextest... but destroying filesystems
> and BIOS errors?!? may not be ideal failure detection modes.

Yup, suse now has a test farm box with a slightly bent up btrfs root.
I'll have to remember to poke the install button when I return it :)

-Mike


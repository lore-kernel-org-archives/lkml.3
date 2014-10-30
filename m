Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaJ3E25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:28:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaJ3E24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:28:56 -0400
Date: Wed, 29 Oct 2014 21:28:53 -0700
From: Darren Hart <dvhart@infradead.org>
To: Brian Silverman <bsilver16384@gmail.com>
Cc: tglx@linutronix.de, Austin Schuh <austin.linux@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: fix a race condition between REQUEUE_PI and task
 death
Message-ID: <20141030042852.GI14609@vmdeb7>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com>
 <CAP01z6LSTyS5FDgZTma96BY5eWycpHgECNwZSy2Afyn2UFH5yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP01z6LSTyS5FDgZTma96BY5eWycpHgECNwZSy2Afyn2UFH5yA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 03:28:07PM -0400, Brian Silverman wrote:
> Here's the test code:
> 

I want to say "Thanks!" and pull it into futextest... but destroying filesystems
and BIOS errors?!? may not be ideal failure detection modes.

(Apologies for being so late to this particular party).

-- 
Darren Hart
Intel Open Source Technology Center

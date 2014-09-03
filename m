Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaICPHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:07:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaICPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:07:44 -0400
Date: Wed, 3 Sep 2014 17:07:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/26] locking: Add non-fatal spin lock assert
Message-ID: <20140903150729.GA7436@twins.programming.kicks-ass.net>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1409693975-1028-14-git-send-email-peter@hurleysoftware.com>
 <20140903092723.GA4783@worktop.ger.corp.intel.com>
 <5406F964.6060900@hurleysoftware.com>
 <20140903144029.GA7083@twins.programming.kicks-ass.net>
 <54072A99.1080306@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54072A99.1080306@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:50:01AM -0400, Peter Hurley wrote:
> So a lockdep-only assert is unlikely to draw attention to existing bugs,
> especially in established drivers.

By the same logic lockdep will not find locking errors in established
drivers.

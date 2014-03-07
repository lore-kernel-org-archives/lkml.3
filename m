Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCGOEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:04:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39738 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaCGOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:04:08 -0500
Date: Fri, 7 Mar 2014 15:04:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atkbd - add LED triggers for keyboard state
Message-ID: <20140307140403.GB17576@Nokia-N900>
References: <1393794356-1754-1-git-send-email-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393794356-1754-1-git-send-email-Jason@zx2c4.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-03-02 22:05:56, Jason A. Donenfeld wrote:
> Many new laptop keyboards aren't shipping with LEDs in the keys for
> caps lock, num lock, and scroll lock. They do, however, ship with many LEDs
> for specialized functions that mostly go non-utilized by any current
> Linux drivers. Having a caps lock LED is very helpful in early boot full
> disk encryption, where a fancy GUI is not available to show that caps
> lock is activated.

There's already patch in akpm tree that does this... and more.

Please help improving it.

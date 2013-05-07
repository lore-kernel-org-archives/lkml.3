Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab3EGU34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:29:56 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:45808 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757778Ab3EGU3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:29:55 -0400
Date: Tue, 7 May 2013 22:29:50 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: unable to fetch the watchdog tree
Message-ID: <20130507202950.GS14155@spo001.leaseweb.com>
References: <20130507101246.1337bb2362b2f9fc202923fc@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507101246.1337bb2362b2f9fc202923fc@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Trying to fetch the watchdog tree
> (git://www.linux-watchdog.org/linux-watchdog-next.git#master)
> pauses for a long time, and then produces this error:
> 
> fatal: read error: Connection reset by peer
> 
> I will continue to use what I previously fetched.

Thanks for pointing it out again. It restarted git-daemon. It should be fixed now.

Only thing I still need to do is catch up from some overloaded work weeks.

Kind regards,
Wim.


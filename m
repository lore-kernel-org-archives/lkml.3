Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3CYHez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:34:55 -0400
Received: from moltke.seatribe.se ([178.63.100.209]:55631 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3CYHey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:34:54 -0400
Date: Mon, 25 Mar 2013 08:34:50 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Eric Wong <normalperson@yhbt.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: I/O blocked while dirty pages are being flushed
In-Reply-To: <20130324065605.GA19984@dcvr.yhbt.net>
Message-ID: <alpine.DEB.2.02.1303250833070.4028@shack.dolda2000.com>
References: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com> <20130324065605.GA19984@dcvr.yhbt.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Mar 2013, Eric Wong wrote:
> Fredrik Tolf <fredrik@dolda2000.com> wrote:
>> It is worth noting, also, that this seems to be a situation
>> introduced somewhere between 2.6.26 and 2.6.32, because I started
>> noticing it when I upgraded from Debian 5.0 to 6.0. I've since tried
>> it on 3.2.0, 3.5.4 and 3.7.1, and it appears in every version.
>> However, I can't easily go back and bisect, because the new init
>> scripts don't support kernels older than 2.6.32, unfortunately.
>
> So try lowering these sysctls to 2.6.26 levels (or lower) and see if
> that helps.

Thanks for the tip, but since the page dirtying happens in fast bursts for 
me, rather than gradually over time, that just caused the same sizes of 
writes to happen more often instead, which only made it worse. :)

I'll continue investigating the stable-page route, instead, since that 
seems to be my exact problem.

--

Fredrik Tolf
